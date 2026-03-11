// import 'package:expense_mate/core/data/models/currency_model.dart';
// import 'package:expense_mate/core/database/db_constants.dart';
// import 'package:expense_mate/core/database/sqflite_helper.dart';

// abstract class CurrencyLocalDataSource {
//   Future<List<CurrencyModel>> getAllCurrencies();
//   Future<CurrencyModel?> getCurrencyByCode(String code);
// }

// // ─────────────────────────────────────────────────────────────────────────────

// class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
//   final SqliteHelper _db = SqliteHelper.instance;

//   @override
//   Future<List<CurrencyModel>> getAllCurrencies() async {
//     try {
//       final rows = await _db.queryAll(
//         DbConstants.tableCurrencies,
//         orderBy: DbConstants.colCurrencyCode,
//       );
//       return rows
//           .map(
//             (r) => CurrencyModel(
//               code: r[DbConstants.colCurrencyCode] as String,
//               name: r[DbConstants.colCurrencyName] as String,
//               symbol: r[DbConstants.colCurrencySymbol] as String,
//               flag: r[DbConstants.colCurrencyFlag] as String,
//             ),
//           )
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get currencies: $e');
//     }
//   }

//   @override
//   Future<CurrencyModel?> getCurrencyByCode(String code) async {
//     try {
//       final rows = await _db.queryWhere(
//         DbConstants.tableCurrencies,
//         where: '${DbConstants.colCurrencyCode} = ?',
//         whereArgs: [code],
//         limit: 1,
//       );
//       if (rows.isEmpty) return null;
//       final r = rows.first;
//       return CurrencyModel(
//         code: r[DbConstants.colCurrencyCode] as String,
//         name: r[DbConstants.colCurrencyName] as String,
//         symbol: r[DbConstants.colCurrencySymbol] as String,
//         flag: r[DbConstants.colCurrencyFlag] as String,
//       );
//     } catch (e) {
//       throw Exception('Failed to get currency: $e');
//     }
//   }
// }
