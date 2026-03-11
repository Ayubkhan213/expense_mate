// import 'package:expense_mate/core/data/models/debt_payment_sql_model.dart';
// import 'package:expense_mate/core/data/models/debt_sql_model.dart';
// import 'package:expense_mate/core/database/db_constants.dart' show DbConstants;
// import 'package:expense_mate/core/database/sqflite_helper.dart';
// import 'package:expense_mate/core/domain/entity/debt_entity.dart';

// abstract class DebtLocalDataSource {
//   Future<String> createDebt(DebtModel debt);
//   Future<DebtModel?> getDebtById(String id);
//   Future<DebtModel?> getDebtByTransactionId(String transactionId);
//   Future<List<DebtModel>> getAllDebts();
//   Future<List<DebtModel>> getActiveDebts();
//   Future<List<DebtModel>> getSettledDebts();
//   Future<List<DebtModel>> getDebtsByType(DebtType type);
//   Future<List<DebtModel>> getOverdueDebts();
//   Future<void> updateDebt(DebtModel debt);
//   Future<void> addPayment(DebtPaymentModel payment);
//   Future<List<DebtPaymentModel>> getPaymentsForDebt(String debtId);
//   Future<void> deleteDebt(String id);
// }

// // ─────────────────────────────────────────────────────────────────────────────

// class DebtLocalDataSourceImpl implements DebtLocalDataSource {
//   final SqliteHelper _db = SqliteHelper.instance;

//   // ═══════════════════════════════════════════════════════════════════════════
//   // DEBTS
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<String> createDebt(DebtModel debt) async {
//     await _db.insert(
//       DbConstants.tableDebts,
//       DebtModel.fromEntity(debt).toMap(),
//     );
//     return debt.id;
//   }

//   @override
//   Future<DebtModel?> getDebtById(String id) async {
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebts,
//       where: '${DbConstants.colId} = ?',
//       whereArgs: [id],
//       limit: 1,
//     );
//     if (rows.isEmpty) return null;
//     return DebtModel.fromMap(rows.first);
//   }

//   @override
//   Future<DebtModel?> getDebtByTransactionId(String transactionId) async {
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebts,
//       where: '${DbConstants.colDebtTransactionId} = ?',
//       whereArgs: [transactionId],
//       limit: 1,
//     );
//     if (rows.isEmpty) return null;
//     return DebtModel.fromMap(rows.first);
//   }

//   @override
//   Future<List<DebtModel>> getAllDebts() async {
//     final rows = await _db.queryAll(
//       DbConstants.tableDebts,
//       orderBy: '${DbConstants.colCreatedAt} DESC',
//     );
//     return rows.map((r) => DebtModel.fromMap(r)).toList();
//   }

//   @override
//   Future<List<DebtModel>> getActiveDebts() async {
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebts,
//       where: '${DbConstants.colDebtIsReturned} = ?',
//       whereArgs: [0],
//       orderBy: '${DbConstants.colDebtExpectedReturnDate} ASC',
//     );
//     return rows.map((r) => DebtModel.fromMap(r)).toList();
//   }

//   @override
//   Future<List<DebtModel>> getSettledDebts() async {
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebts,
//       where: '${DbConstants.colDebtIsReturned} = ?',
//       whereArgs: [1],
//       orderBy: '${DbConstants.colUpdatedAt} DESC',
//     );
//     return rows.map((r) => DebtModel.fromMap(r)).toList();
//   }

//   @override
//   Future<List<DebtModel>> getDebtsByType(DebtType type) async {
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebts,
//       where: '${DbConstants.colDebtType} = ?',
//       whereArgs: [type.name],
//       orderBy: '${DbConstants.colCreatedAt} DESC',
//     );
//     return rows.map((r) => DebtModel.fromMap(r)).toList();
//   }

//   @override
//   Future<List<DebtModel>> getOverdueDebts() async {
//     // Overdue = not returned AND expected_return_date < now
//     final now = DateTime.now().toIso8601String();
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebts,
//       where:
//           '${DbConstants.colDebtIsReturned} = ? AND ${DbConstants.colDebtExpectedReturnDate} < ?',
//       whereArgs: [0, now],
//       orderBy: '${DbConstants.colDebtExpectedReturnDate} ASC',
//     );
//     return rows.map((r) => DebtModel.fromMap(r)).toList();
//   }

//   @override
//   Future<void> updateDebt(DebtModel debt) async {
//     await _db.update(
//       DbConstants.tableDebts,
//       DebtModel.fromEntity(debt).toMap()
//         ..['updated_at'] = DateTime.now().toIso8601String(),
//       where: '${DbConstants.colId} = ?',
//       whereArgs: [debt.id],
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // PAYMENTS
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<void> addPayment(DebtPaymentModel payment) async {
//     await _db.runTransaction((txn) async {
//       // 1. Insert the payment
//       await txn.insert(
//         DbConstants.tableDebtPayments,
//         DebtPaymentModel.fromEntity(payment).toMap(),
//       );

//       // 2. Read current debt
//       final debtRows = await txn.query(
//         DbConstants.tableDebts,
//         where: '${DbConstants.colId} = ?',
//         whereArgs: [payment.debtId],
//         limit: 1,
//       );
//       if (debtRows.isEmpty) throw Exception('Debt ${payment.debtId} not found');

//       final debt = DebtModel.fromMap(debtRows.first);
//       final newPaidAmount = debt.paidAmount + payment.amount;
//       final isFullyPaid = newPaidAmount >= debt.totalAmount;

//       // 3. Update paid_amount and is_returned atomically
//       await txn.update(
//         DbConstants.tableDebts,
//         {
//           DbConstants.colDebtPaidAmount: newPaidAmount,
//           DbConstants.colDebtIsReturned: isFullyPaid ? 1 : 0,
//           DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
//         },
//         where: '${DbConstants.colId} = ?',
//         whereArgs: [payment.debtId],
//       );
//     });
//   }

//   @override
//   Future<List<DebtPaymentModel>> getPaymentsForDebt(String debtId) async {
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebtPayments,
//       where: '${DbConstants.colDebtPaymentDebtId} = ?',
//       whereArgs: [debtId],
//       orderBy: '${DbConstants.colDebtPaymentDate} DESC',
//     );
//     return rows.map((r) => DebtPaymentModel.fromMap(r)).toList();
//   }

//   @override
//   Future<void> deleteDebt(String id) async {
//     // Payments are deleted via ON DELETE CASCADE on the debt_payments table
//     await _db.delete(
//       DbConstants.tableDebts,
//       where: '${DbConstants.colId} = ?',
//       whereArgs: [id],
//     );
//   }
// }
