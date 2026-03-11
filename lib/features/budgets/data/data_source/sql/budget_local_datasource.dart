import 'package:expense_mate/core/data/models/budget_sql_model.dart';
import 'package:expense_mate/core/data/models/transcation_item_sql_model.dart';
import 'package:expense_mate/core/data/models/transcation_sql_model.dart';
import 'package:expense_mate/core/database/db_constants.dart';
import 'package:expense_mate/core/database/sqflite_helper.dart';
import 'package:expense_mate/core/domain/entity/budget_entity.dart';
import 'package:expense_mate/core/domain/entity/transcation_item_entity.dart';

abstract class BudgetLocalDataSource {
  Future<String> createBudget(BudgetModel budget);
  Future<BudgetModel?> getBudgetById(String id);
  Future<List<BudgetModel>> getAllBudgets();
  Future<List<BudgetModel>> getActiveBudgets();
  Future<List<BudgetModel>> getArchivedBudgets();
  Future<List<BudgetModel>> getBudgetsByType(BudgetType type);
  Future<List<BudgetModel>> getOverBudgets();
  Future<List<BudgetModel>> getExpiredBudgets();
  Future<void> updateBudget(BudgetModel budget);
  Future<List<TransactionModel>> getTransactionsByBudget(String budgetId);
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  );
  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  );
  Future<void> archiveBudget(String id);
  Future<void> deleteBudget(String id);
}

// ─────────────────────────────────────────────────────────────────────────────

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final SqliteHelper _db = SqliteHelper.instance;

  // ── private helper ─────────────────────────────────────────────────────────

  /// Patch a single budget row without fetching and rewriting everything.
  Future<void> _patchBudget(
    String budgetId,
    Map<String, dynamic> fields,
  ) async {
    await _db.update(
      DbConstants.tableBudgets,
      {...fields, DbConstants.colUpdatedAt: DateTime.now().toIso8601String()},
      where: '${DbConstants.colId} = ?',
      whereArgs: [budgetId],
    );
  }

  /// Build a full [TransactionModel] (items fetched from child table).
  Future<TransactionModel> _buildTransaction(Map<String, dynamic> row) async {
    final itemRows = await _db.queryWhere(
      DbConstants.tableTransactionItems,
      where: '${DbConstants.colTxnItemTransactionId} = ?',
      whereArgs: [row['id'] as String],
    );
    // TransactionItemModel extends TransactionItemEntity — upcast is safe
    final items = itemRows
        .map<TransactionItemEntity>((r) => TransactionItemModel.fromMap(r))
        .toList();
    return TransactionModel.fromMap(row, items);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<String> createBudget(BudgetModel budget) async {
    await _db.insert(
      DbConstants.tableBudgets,
      BudgetModel.fromEntity(budget).toMap(),
    );
    return budget.id;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // READ
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<BudgetModel?> getBudgetById(String id) async {
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return BudgetModel.fromMap(rows.first);
  }

  @override
  Future<List<BudgetModel>> getAllBudgets() async {
    final rows = await _db.queryAll(
      DbConstants.tableBudgets,
      orderBy: '${DbConstants.colCreatedAt} DESC',
    );
    return rows.map((r) => BudgetModel.fromMap(r)).toList();
  }

  @override
  Future<List<BudgetModel>> getActiveBudgets() async {
    final now = DateTime.now().toIso8601String();
    // Active = is_active=1, not archived, end_date not yet passed
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colIsActive} = 1 '
          'AND ${DbConstants.colBudgetIsArchived} = 0 '
          'AND ${DbConstants.colBudgetEndDate} >= ?',
      whereArgs: [now],
      orderBy: '${DbConstants.colBudgetEndDate} ASC',
    );
    return rows.map((r) => BudgetModel.fromMap(r)).toList();
  }

  @override
  Future<List<BudgetModel>> getArchivedBudgets() async {
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where: '${DbConstants.colBudgetIsArchived} = ?',
      whereArgs: [1],
      orderBy: '${DbConstants.colUpdatedAt} DESC',
    );
    return rows.map((r) => BudgetModel.fromMap(r)).toList();
  }

  @override
  Future<List<BudgetModel>> getBudgetsByType(BudgetType type) async {
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colBudgetType} = ? '
          'AND ${DbConstants.colBudgetIsArchived} = 0',
      whereArgs: [type.name],
      orderBy: '${DbConstants.colCreatedAt} DESC',
    );
    return rows.map((r) => BudgetModel.fromMap(r)).toList();
  }

  @override
  Future<List<BudgetModel>> getOverBudgets() async {
    // spent_amount > total_amount and not archived
    final rows = await _db.rawQuery('''
      SELECT * FROM ${DbConstants.tableBudgets}
      WHERE ${DbConstants.colBudgetSpentAmount} > ${DbConstants.colBudgetTotalAmount}
        AND ${DbConstants.colBudgetIsArchived} = 0
      ORDER BY ${DbConstants.colBudgetSpentAmount} DESC
    ''');
    return rows.map((r) => BudgetModel.fromMap(r)).toList();
  }

  @override
  Future<List<BudgetModel>> getExpiredBudgets() async {
    final now = DateTime.now().toIso8601String();
    // end_date has passed and not archived
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colBudgetEndDate} < ? '
          'AND ${DbConstants.colBudgetIsArchived} = 0',
      whereArgs: [now],
      orderBy: '${DbConstants.colBudgetEndDate} DESC',
    );
    return rows.map((r) => BudgetModel.fromMap(r)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByBudget(
    String budgetId,
  ) async {
    // Transactions that reference this budget and are not soft-deleted
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where:
          '${DbConstants.colTxnBudgetId} = ? '
          'AND ${DbConstants.colIsDeleted} = 0',
      whereArgs: [budgetId],
      orderBy: '${DbConstants.colTxnDate} DESC',
    );
    return Future.wait(rows.map((r) => _buildTransaction(r)));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _db.update(
      DbConstants.tableBudgets,
      BudgetModel.fromEntity(budget).toMap()
        ..[DbConstants.colUpdatedAt] = DateTime.now().toIso8601String(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) async {
    // In SQLite the transaction list is not stored on the budget row —
    // the transaction itself carries budget_id. So we just:
    // 1. Point the transaction at this budget.
    // 2. Increment spent_amount on the budget atomically.
    await _db.runTransaction((txn) async {
      // Update the transaction's budget_id
      await txn.update(
        DbConstants.tableTransactions,
        {
          DbConstants.colTxnBudgetId: budgetId,
          DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
        },
        where: '${DbConstants.colId} = ?',
        whereArgs: [transactionId],
      );

      // Increment spent_amount on the budget
      await txn.rawUpdate(
        '''
        UPDATE ${DbConstants.tableBudgets}
        SET ${DbConstants.colBudgetSpentAmount} = ${DbConstants.colBudgetSpentAmount} + ?,
            ${DbConstants.colUpdatedAt} = ?
        WHERE ${DbConstants.colId} = ?
      ''',
        [amount, DateTime.now().toIso8601String(), budgetId],
      );
    });
  }

  @override
  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) async {
    await _db.runTransaction((txn) async {
      // Clear the budget_id on the transaction
      await txn.update(
        DbConstants.tableTransactions,
        {
          DbConstants.colTxnBudgetId: null,
          DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
        },
        where: '${DbConstants.colId} = ?',
        whereArgs: [transactionId],
      );

      // Decrement spent_amount, clamped to 0 via MAX()
      await txn.rawUpdate(
        '''
        UPDATE ${DbConstants.tableBudgets}
        SET ${DbConstants.colBudgetSpentAmount} = MAX(0, ${DbConstants.colBudgetSpentAmount} - ?),
            ${DbConstants.colUpdatedAt} = ?
        WHERE ${DbConstants.colId} = ?
      ''',
        [amount, DateTime.now().toIso8601String(), budgetId],
      );
    });
  }

  @override
  Future<void> archiveBudget(String id) async {
    await _patchBudget(id, {
      DbConstants.colIsActive: 0,
      DbConstants.colBudgetIsArchived: 1,
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> deleteBudget(String id) async {
    await _db.delete(
      DbConstants.tableBudgets,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
  }
}
