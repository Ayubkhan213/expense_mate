// import 'package:expense_mate/core/data/models/debt_sql_model.dart';
// import 'package:expense_mate/core/database/db_constants.dart';
// import 'package:expense_mate/core/database/sqflite_helper.dart';

// import '../../../../../core/data/models/debt_payment_sql_model.dart';

// abstract class HomeDatasource {
//   Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId);
//   Future<List<DebtModel>> getAllDebts();
// }

// // ─────────────────────────────────────────────────────────────────────────────

// class HomeDatasourceImpl implements HomeDatasource {
//   final SqliteHelper _db = SqliteHelper.instance;

//   @override
//   Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId) async {
//     final rows = await _db.queryWhere(
//       DbConstants.tableDebtPayments,
//       where: '${DbConstants.colDebtPaymentDebtId} = ?',
//       whereArgs: [debtId],
//       orderBy: '${DbConstants.colDebtPaymentDate} DESC',
//     );
//     return rows.map((r) => DebtPaymentModel.fromMap(r)).toList();
//   }

//   @override
//   Future<List<DebtModel>> getAllDebts() async {
//     final rows = await _db.queryAll(
//       DbConstants.tableDebts,
//       orderBy: '${DbConstants.colCreatedAt} DESC',
//     );
//     return rows.map((r) => DebtModel.fromMap(r)).toList();
//   }
// }
