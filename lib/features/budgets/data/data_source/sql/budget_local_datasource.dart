import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_item_sql_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/domain/entity/transcation_item_entity.dart';
import 'package:spendio/core/services/app_prefs.dart';

import '../../../../../core/data/models/budget_model.dart';

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

  String get _userId => AppPrefs.instance.userId ?? '';

  // ── private helpers ────────────────────────────────────────────────────────

  Future<List<String>> _getTransactionIds(String budgetId) async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      columns: [DbConstants.colId],
      where:
          '${DbConstants.colTxnBudgetId} = ? '
          'AND ${DbConstants.colIsDeleted} = 0 '
          'AND ${DbConstants.colUserId} = ?',
      whereArgs: [budgetId, _userId],
    );
    return rows.map((r) => r[DbConstants.colId] as String).toList();
  }

  Future<BudgetModel> _buildBudget(Map<String, dynamic> row) async {
    final budgetId = row['id'] as String;
    final txnIds = await _getTransactionIds(budgetId);

    // ✅ Calculate actual spent amount from transactions table (source of truth)
    final spentRows = await _db.rawQuery(
      'SELECT SUM(${DbConstants.colTxnTotalAmount}) as total '
      'FROM ${DbConstants.tableTransactions} '
      'WHERE ${DbConstants.colTxnBudgetId} = ? '
      'AND ${DbConstants.colIsDeleted} = 0 '
      'AND ${DbConstants.colUserId} = ?',
      [budgetId, _userId],
    );
    final actualSpent = (spentRows.first['total'] as num?)?.toDouble() ?? 0.0;

    // ✅ Create a mutable copy and override the potentially outdated spent_amount
    final updatedRow = Map<String, dynamic>.from(row);
    updatedRow[DbConstants.colBudgetSpentAmount] = actualSpent;

    return BudgetModel.fromMap(updatedRow, transactionIds: txnIds);
  }

  Future<TransactionModel> _buildTransaction(Map<String, dynamic> row) async {
    final itemRows = await _db.queryWhere(
      DbConstants.tableTransactionItems,
      where: '${DbConstants.colTxnItemTransactionId} = ?',
      whereArgs: [row['id'] as String],
    );
    final items = itemRows
        .map<TransactionItemEntity>((r) => TransactionItemModel.fromMap(r))
        .toList();
    return TransactionModel.fromMap(row, items);
  }

  Future<void> _patchBudget(
    String budgetId,
    Map<String, dynamic> fields,
  ) async {
    await _db.update(
      DbConstants.tableBudgets,
      {...fields, DbConstants.colUpdatedAt: DateTime.now().toIso8601String()},
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [budgetId, _userId],
    );
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
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _buildBudget(rows.first);
  }

  @override
  Future<List<BudgetModel>> getAllBudgets() async {
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where: '${DbConstants.colUserId} = ?',
      whereArgs: [_userId],
      orderBy: '${DbConstants.colCreatedAt} DESC',
    );
    return Future.wait(rows.map((r) => _buildBudget(r)));
  }

  @override
  Future<List<BudgetModel>> getActiveBudgets() async {
    final now = DateTime.now().toIso8601String();
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colIsActive} = 1 '
          'AND ${DbConstants.colBudgetIsArchived} = 0 '
          'AND ${DbConstants.colBudgetEndDate} >= ?',
      whereArgs: [_userId, now],
      orderBy: '${DbConstants.colBudgetEndDate} ASC',
    );
    return Future.wait(rows.map((r) => _buildBudget(r)));
  }

  @override
  Future<List<BudgetModel>> getArchivedBudgets() async {
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colBudgetIsArchived} = ?',
      whereArgs: [_userId, 1],
      orderBy: '${DbConstants.colUpdatedAt} DESC',
    );
    return Future.wait(rows.map((r) => _buildBudget(r)));
  }

  @override
  Future<List<BudgetModel>> getBudgetsByType(BudgetType type) async {
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colBudgetType} = ? '
          'AND ${DbConstants.colBudgetIsArchived} = 0',
      whereArgs: [_userId, type.name],
      orderBy: '${DbConstants.colCreatedAt} DESC',
    );
    return Future.wait(rows.map((r) => _buildBudget(r)));
  }

  @override
  Future<List<BudgetModel>> getOverBudgets() async {
    // ✅ Use a subquery to calculate actual spent amount for filtering and sorting
    final rows = await _db.rawQuery(
      '''
      SELECT b.*, 
             (SELECT SUM(t.${DbConstants.colTxnTotalAmount}) 
              FROM ${DbConstants.tableTransactions} t 
              WHERE t.${DbConstants.colTxnBudgetId} = b.${DbConstants.colId} 
                AND t.${DbConstants.colIsDeleted} = 0
                AND t.${DbConstants.colUserId} = ?) as actual_spent
      FROM ${DbConstants.tableBudgets} b
      WHERE b.${DbConstants.colUserId} = ?
        AND actual_spent > b.${DbConstants.colBudgetTotalAmount}
        AND b.${DbConstants.colBudgetIsArchived} = 0
      ORDER BY actual_spent DESC
      ''',
      [_userId, _userId],
    );
    return Future.wait(rows.map((r) => _buildBudget(r)));
  }

  @override
  Future<List<BudgetModel>> getExpiredBudgets() async {
    final now = DateTime.now().toIso8601String();
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colBudgetEndDate} < ? '
          'AND ${DbConstants.colBudgetIsArchived} = 0',
      whereArgs: [_userId, now],
      orderBy: '${DbConstants.colBudgetEndDate} DESC',
    );
    return Future.wait(rows.map((r) => _buildBudget(r)));
  }

  @override
  Future<List<TransactionModel>> getTransactionsByBudget(
    String budgetId,
  ) async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where:
          '${DbConstants.colTxnBudgetId} = ? '
          'AND ${DbConstants.colIsDeleted} = 0 '
          'AND ${DbConstants.colUserId} = ?',
      whereArgs: [budgetId, _userId],
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
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [budget.id, _userId],
    );
  }

  @override
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) async {
    await _db.runTransaction((txn) async {
      await txn.update(
        DbConstants.tableTransactions,
        {
          DbConstants.colTxnBudgetId: budgetId,
          DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
        },
        where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
        whereArgs: [transactionId, _userId],
      );
      await txn.rawUpdate(
        '''
        UPDATE ${DbConstants.tableBudgets}
        SET ${DbConstants.colBudgetSpentAmount} =
              ${DbConstants.colBudgetSpentAmount} + ?,
            ${DbConstants.colUpdatedAt} = ?
        WHERE ${DbConstants.colId} = ?
          AND ${DbConstants.colUserId} = ?
        ''',
        [amount, DateTime.now().toIso8601String(), budgetId, _userId],
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
      await txn.update(
        DbConstants.tableTransactions,
        {
          DbConstants.colTxnBudgetId: null,
          DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
        },
        where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
        whereArgs: [transactionId, _userId],
      );
      await txn.rawUpdate(
        '''
        UPDATE ${DbConstants.tableBudgets}
        SET ${DbConstants.colBudgetSpentAmount} =
              MAX(0, ${DbConstants.colBudgetSpentAmount} - ?),
            ${DbConstants.colUpdatedAt} = ?
        WHERE ${DbConstants.colId} = ?
          AND ${DbConstants.colUserId} = ?
        ''',
        [amount, DateTime.now().toIso8601String(), budgetId, _userId],
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
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
    );
  }
}
