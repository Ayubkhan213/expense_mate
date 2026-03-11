// import 'package:expense_mate/core/data/models/currency_model.dart';

// import 'package:expense_mate/core/database/db_constants.dart';
// import 'package:expense_mate/core/database/sqflite_helper.dart';

// class CurrenciesSeeding {
//   static final SqliteHelper _db = SqliteHelper.instance;

//   /// Seeds all pre-defined currencies on first launch.
//   static Future<void> seedCurrenciesIfFirstTime() async {
//     final existing = await _db.queryAll(DbConstants.tableCurrencies);
//     if (existing.isNotEmpty) return;

//     print('🌍 Seeding currencies...');

//     final rows = CurrencyList.currencies
//         .map(
//           (c) => {
//             DbConstants.colCurrencyCode: c.code,
//             DbConstants.colCurrencyName: c.name,
//             DbConstants.colCurrencySymbol: c.symbol,
//             DbConstants.colCurrencyFlag: c.flag,
//           },
//         )
//         .toList();

//     await _db.insertBatch(DbConstants.tableCurrencies, rows);

//     print('✅ ${rows.length} currencies seeded!');
//   }
// }
