import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_item_sql_model.dart';
import 'package:spendio/core/data/models/transcation_result.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/domain/entity/transcation_item_entity.dart';
import 'package:spendio/core/services/app_prefs.dart';

abstract class TransactionLocalDataSource {
  Future<TransactionResult> createTransaction(TransactionModel transaction);
  Future<TransactionModel?> getTransactionById(String id);
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<TransactionModel>> getTransactionsByType(TransactionType type);
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryKey);
  Future<List<TransactionModel>> getDebtTransactions();
  Future<List<TransactionModel>> getRecurringTransactions();
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> permanentlyDeleteTransaction(String id);

  Future<TransactionResult> createDebt(DebtModel debt);
  Future<DebtModel?> getDebtById(String id);
  Future<List<DebtModel>> getAllDebts();
  Future<void> updateDebt(DebtModel debt);
  Future<void> deleteDebt(String id);

  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment);
  Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId);
  Future<List<DebtPaymentModel>> getAllDebtPayments();

  Future<void> updateBudget(BudgetModel budget);
}

// ─────────────────────────────────────────────────────────────────────────────

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final SqliteHelper _db = SqliteHelper.instance;

  // ── Get current logged-in user ID ─────────────────────────────────────────
  String get _userId => AppPrefs.instance.userId ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<List<TransactionItemEntity>> _getItemsForTransaction(
    String transactionId,
  ) async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactionItems,
      where: '${DbConstants.colTxnItemTransactionId} = ?',
      whereArgs: [transactionId],
    );
    return rows
        .map<TransactionItemEntity>((r) => TransactionItemModel.fromMap(r))
        .toList();
  }

  Future<TransactionModel> _buildTransaction(Map<String, dynamic> row) async {
    final items = await _getItemsForTransaction(row['id'] as String);
    return TransactionModel.fromMap(row, items);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<TransactionResult> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      await _db.runTransaction((txn) async {
        await txn.insert(DbConstants.tableTransactions, transaction.toMap());
        for (final item in transaction.items) {
          final itemModel = TransactionItemModel(
            transactionId: transaction.id,
            category: item.category,
            amount: item.amount,
            note: item.note,
          );
          await txn.insert(
            DbConstants.tableTransactionItems,
            itemModel.toMap(),
          );
        }
      });
      return TransactionResult(
        success: true,
        message: 'Transaction added successfully',
        transactionId: transaction.id,
      );
    } catch (e, st) {
      print('createTransaction error: $e\n$st');
      return TransactionResult(
        success: false,
        message: 'Failed to add transaction',
      );
    }
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _buildTransaction(rows.first);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where: '${DbConstants.colIsDeleted} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [0, _userId],
      orderBy: '${DbConstants.colTxnDate} DESC',
    );
    return Future.wait(rows.map(_buildTransaction));
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where:
          '${DbConstants.colIsDeleted} = ? '
          'AND ${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colTxnDate} >= ? '
          'AND ${DbConstants.colTxnDate} <= ?',
      whereArgs: [
        0,
        _userId,
        startDate.toIso8601String(),
        endDate
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1))
            .toIso8601String(),
      ],
      orderBy: '${DbConstants.colTxnDate} DESC',
    );
    return Future.wait(rows.map(_buildTransaction));
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(
    TransactionType type,
  ) async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where:
          '${DbConstants.colIsDeleted} = ? '
          'AND ${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colTxnType} = ?',
      whereArgs: [0, _userId, type.name],
      orderBy: '${DbConstants.colTxnDate} DESC',
    );
    return Future.wait(rows.map(_buildTransaction));
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(
    String categoryKey,
  ) async {
    final rows = await _db.rawQuery(
      '''
      SELECT DISTINCT t.* FROM ${DbConstants.tableTransactions} t
      INNER JOIN ${DbConstants.tableTransactionItems} i
        ON i.${DbConstants.colTxnItemTransactionId} = t.${DbConstants.colId}
      WHERE t.${DbConstants.colIsDeleted} = 0
        AND t.${DbConstants.colUserId} = ?
        AND i.${DbConstants.colTxnItemCategory} = ?
      ORDER BY t.${DbConstants.colTxnDate} DESC
      ''',
      [_userId, categoryKey],
    );
    return Future.wait(rows.map(_buildTransaction));
  }

  @override
  Future<List<TransactionModel>> getDebtTransactions() async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where:
          '${DbConstants.colIsDeleted} = ? '
          'AND ${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colTxnIsDebt} = ?',
      whereArgs: [0, _userId, 1],
      orderBy: '${DbConstants.colTxnDate} DESC',
    );
    return Future.wait(rows.map(_buildTransaction));
  }

  @override
  Future<List<TransactionModel>> getRecurringTransactions() async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where:
          '${DbConstants.colIsDeleted} = ? '
          'AND ${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colTxnIsRecurring} = ?',
      whereArgs: [0, _userId, 1],
      orderBy: '${DbConstants.colTxnDate} DESC',
    );
    return Future.wait(rows.map(_buildTransaction));
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _db.runTransaction((txn) async {
      await txn.update(
        DbConstants.tableTransactions,
        transaction.toMap()..['updated_at'] = DateTime.now().toIso8601String(),
        where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
        whereArgs: [transaction.id, _userId],
      );
      await txn.delete(
        DbConstants.tableTransactionItems,
        where: '${DbConstants.colTxnItemTransactionId} = ?',
        whereArgs: [transaction.id],
      );
      for (final item in transaction.items) {
        final itemModel = TransactionItemModel(
          transactionId: transaction.id,
          category: item.category,
          amount: item.amount,
          note: item.note,
        );
        await txn.insert(DbConstants.tableTransactionItems, itemModel.toMap());
      }
    });
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _db.update(
      DbConstants.tableTransactions,
      {
        DbConstants.colIsDeleted: 1,
        DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
    );
  }

  @override
  Future<void> permanentlyDeleteTransaction(String id) async {
    await _db.delete(
      DbConstants.tableTransactions,
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DEBTS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<TransactionResult> createDebt(DebtModel debt) async {
    try {
      await _db.insert(
        DbConstants.tableDebts,
        DebtModel.fromEntity(debt).toMap(),
      );
      return TransactionResult(
        success: true,
        message: 'Debt created successfully',
        transactionId: debt.id,
      );
    } catch (e, st) {
      print('createDebt error: $e\n$st');
      return TransactionResult(
        success: false,
        message: 'Failed to create debt',
      );
    }
  }

  @override
  Future<DebtModel?> getDebtById(String id) async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DebtModel.fromMap(rows.first);
  }

  @override
  Future<List<DebtModel>> getAllDebts() async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where: '${DbConstants.colUserId} = ?',
      whereArgs: [_userId],
      orderBy: '${DbConstants.colCreatedAt} DESC',
    );
    return rows.map((r) => DebtModel.fromMap(r)).toList();
  }

  @override
  Future<void> updateDebt(DebtModel debt) async {
    await _db.update(
      DbConstants.tableDebts,
      DebtModel.fromEntity(debt).toMap()
        ..['updated_at'] = DateTime.now().toIso8601String(),
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [debt.id, _userId],
    );
  }

  @override
  Future<void> deleteDebt(String id) async {
    await _db.delete(
      DbConstants.tableDebts,
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DEBT PAYMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment) async {
    try {
      await _db.runTransaction((txn) async {
        await txn.insert(
          DbConstants.tableDebtPayments,
          DebtPaymentModel.fromEntity(payment).toMap(),
        );
        final debtRows = await txn.query(
          DbConstants.tableDebts,
          where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
          whereArgs: [payment.debtId, _userId],
          limit: 1,
        );
        if (debtRows.isEmpty) throw Exception('Debt not found');
        final debt = DebtModel.fromMap(debtRows.first);
        final newPaidAmount = debt.paidAmount + payment.amount;
        final isReturned = newPaidAmount >= debt.totalAmount;
        await txn.update(
          DbConstants.tableDebts,
          {
            DbConstants.colDebtPaidAmount: newPaidAmount,
            DbConstants.colDebtIsReturned: isReturned ? 1 : 0,
            DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
          },
          where: '${DbConstants.colId} = ?',
          whereArgs: [payment.debtId],
        );
      });
      return TransactionResult(
        success: true,
        message: 'Payment added successfully',
        transactionId: payment.transactionId,
      );
    } catch (e, st) {
      print('addDebtPayment error: $e\n$st');
      return TransactionResult(
        success: false,
        message: 'Failed to add payment',
      );
    }
  }

  @override
  Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId) async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebtPayments,
      where: '${DbConstants.colDebtPaymentDebtId} = ?',
      whereArgs: [debtId],
      orderBy: '${DbConstants.colDebtPaymentDate} DESC',
    );
    return rows.map((r) => DebtPaymentModel.fromMap(r)).toList();
  }

  @override
  Future<List<DebtPaymentModel>> getAllDebtPayments() async {
    final rows = await _db.rawQuery(
      '''
      SELECT dp.* FROM ${DbConstants.tableDebtPayments} dp
      INNER JOIN ${DbConstants.tableDebts} d ON d.${DbConstants.colId} = dp.${DbConstants.colDebtPaymentDebtId}
      WHERE d.${DbConstants.colUserId} = ?
      ORDER BY dp.${DbConstants.colDebtPaymentDate} DESC
      ''',
      [_userId],
    );
    return rows.map((r) => DebtPaymentModel.fromMap(r)).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _db.update(
        DbConstants.tableBudgets,
        BudgetModel.fromEntity(budget).toMap()
          ..['updated_at'] = DateTime.now().toIso8601String(),
        where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
        whereArgs: [budget.id, _userId],
      );
    } catch (e) {
      print('updateBudget error: $e');
    }
  }
}
