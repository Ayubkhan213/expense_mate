import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/services/app_prefs.dart';

abstract class DebtLocalDataSource {
  Future<String> createDebt(DebtModel debt);
  Future<DebtModel?> getDebtById(String id);
  Future<DebtModel?> getDebtByTransactionId(String transactionId);
  Future<List<DebtModel>> getAllDebts();
  Future<List<DebtModel>> getActiveDebts();
  Future<List<DebtModel>> getSettledDebts();
  Future<List<DebtModel>> getDebtsByType(DebtType type);
  Future<List<DebtModel>> getOverdueDebts();
  Future<void> updateDebt(DebtModel debt);
  Future<void> addPayment(DebtPaymentModel payment);
  Future<List<DebtPaymentModel>> getPaymentsForDebt(String debtId);
  Future<void> deleteDebt(String id);
  Future<void> deletePayment(String paymentId);
}

// ─────────────────────────────────────────────────────────────────────────────

class DebtLocalDataSourceImpl implements DebtLocalDataSource {
  final SqliteHelper _db = SqliteHelper.instance;

  String get _userId => AppPrefs.instance.userId ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // DEBTS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<String> createDebt(DebtModel debt) async {
    await _db.insert(
      DbConstants.tableDebts,
      DebtModel.fromEntity(debt).toMap(),
    );
    return debt.id;
  }

  @override
  Future<void> deletePayment(String paymentId) async {
    await _db.delete(
      DbConstants.tableDebtPayments,
      where: '${DbConstants.colId} = ?',
      whereArgs: [paymentId],
    );
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
  Future<DebtModel?> getDebtByTransactionId(String transactionId) async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where:
          '${DbConstants.colDebtTransactionId} = ? '
          'AND ${DbConstants.colUserId} = ?',
      whereArgs: [transactionId, _userId],
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
  Future<List<DebtModel>> getActiveDebts() async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where:
          '${DbConstants.colDebtIsReturned} = ? '
          'AND ${DbConstants.colUserId} = ?',
      whereArgs: [0, _userId],
      orderBy: '${DbConstants.colDebtExpectedReturnDate} ASC',
    );
    print('========= Rows Data ================');
    return rows.map((r) => DebtModel.fromMap(r)).toList();
  }

  @override
  Future<List<DebtModel>> getSettledDebts() async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where:
          '${DbConstants.colDebtIsReturned} = ? '
          'AND ${DbConstants.colUserId} = ?',
      whereArgs: [1, _userId],
      orderBy: '${DbConstants.colUpdatedAt} DESC',
    );
    return rows.map((r) => DebtModel.fromMap(r)).toList();
  }

  @override
  Future<List<DebtModel>> getDebtsByType(DebtType type) async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where:
          '${DbConstants.colDebtType} = ? '
          'AND ${DbConstants.colUserId} = ?',
      whereArgs: [type.name, _userId],
      orderBy: '${DbConstants.colCreatedAt} DESC',
    );
    return rows.map((r) => DebtModel.fromMap(r)).toList();
  }

  @override
  Future<List<DebtModel>> getOverdueDebts() async {
    final now = DateTime.now().toIso8601String();
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where:
          '${DbConstants.colDebtIsReturned} = ? '
          'AND ${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colDebtExpectedReturnDate} < ?',
      whereArgs: [0, _userId, now],
      orderBy: '${DbConstants.colDebtExpectedReturnDate} ASC',
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

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> addPayment(DebtPaymentModel payment) async {
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
      if (debtRows.isEmpty) throw Exception('Debt ${payment.debtId} not found');
      final debt = DebtModel.fromMap(debtRows.first);
      final newPaidAmount = debt.paidAmount + payment.amount;
      final isFullyPaid = newPaidAmount >= debt.totalAmount;
      await txn.update(
        DbConstants.tableDebts,
        {
          DbConstants.colDebtPaidAmount: newPaidAmount,
          DbConstants.colDebtIsReturned: isFullyPaid ? 1 : 0,
          DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
        },
        where: '${DbConstants.colId} = ?',
        whereArgs: [payment.debtId],
      );
    });
  }

  @override
  Future<List<DebtPaymentModel>> getPaymentsForDebt(String debtId) async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebtPayments,
      where: '${DbConstants.colDebtPaymentDebtId} = ?',
      whereArgs: [debtId],
      orderBy: '${DbConstants.colDebtPaymentDate} DESC',
    );
    return rows.map((r) => DebtPaymentModel.fromMap(r)).toList();
  }

  @override
  Future<void> deleteDebt(String id) async {
    await _db.delete(
      DbConstants.tableDebts,
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [id, _userId],
    );
  }
}
