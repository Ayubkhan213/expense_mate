import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/services/app_prefs.dart';

import '../../../../core/data/models/debt_payment_sql_model.dart';

abstract class HomeDatasource {
  Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId);
  Future<List<DebtModel>> getAllDebts();
  Future<void> deleteDebtWithCascade(DebtModel debt);
}

// ─────────────────────────────────────────────────────────────────────────────

class HomeDatasourceImpl implements HomeDatasource {
  final SqliteHelper _db = SqliteHelper.instance;

  String get _userId => AppPrefs.instance.userId ?? '';

  @override
  Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId) async {
    // Verify the debt belongs to current user before returning payments
    final debtRows = await _db.queryWhere(
      DbConstants.tableDebts,
      where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
      whereArgs: [debtId, _userId],
      limit: 1,
    );
    if (debtRows.isEmpty) return [];

    final rows = await _db.queryWhere(
      DbConstants.tableDebtPayments,
      where: '${DbConstants.colDebtPaymentDebtId} = ?',
      whereArgs: [debtId],
      orderBy: '${DbConstants.colDebtPaymentDate} DESC',
    );
    return rows.map((r) => DebtPaymentModel.fromMap(r)).toList();
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
  Future<void> deleteDebtWithCascade(DebtModel debt) async {
    await _db.runTransaction((txn) async {
      // 1. Delete all payments for this debt
      await txn.delete(
        DbConstants.tableDebtPayments,
        where: '${DbConstants.colDebtPaymentDebtId} = ?',
        whereArgs: [debt.id],
      );

      // 2. Soft-delete the linked transaction
      if (debt.transactionId != null) {
        await txn.update(
          DbConstants.tableTransactions,
          {
            DbConstants.colIsDeleted: 1,
            DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
          },
          where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
          whereArgs: [debt.transactionId, _userId],
        );
      }

      // 3. Delete the debt itself
      await txn.delete(
        DbConstants.tableDebts,
        where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
        whereArgs: [debt.id, _userId],
      );
    });
  }
}
