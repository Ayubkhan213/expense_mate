// import 'package:expense_mate/core/data/models/category_sql_model.dart';

// import 'package:expense_mate/core/database/db_constants.dart';
// import 'package:expense_mate/core/database/sqflite_helper.dart';
// import 'package:expense_mate/core/utils/utils.dart';

// class CategorySeeder {
//   static final SqliteHelper _db = SqliteHelper.instance;

//   /// Seeds income and expense categories on first launch.
//   /// Safe to call every time — checks for existing rows first.
//   static Future<void> seedIfFirstTime() async {
//     final existing = await _db.queryAll(DbConstants.tableCategories);

//     // Already seeded → do nothing
//     if (existing.isNotEmpty) return;

//     final utils = Utils();
//     final now = DateTime.now().toIso8601String();

//     final List<Map<String, dynamic>> rows = [];

//     for (final item in utils.incomeCategories) {
//       rows.add(
//         CategoryModel(
//           key: item.keyName,
//           iconCode: item.icon.codePoint,
//           colorValue: item.color.value,
//           isIncome: true,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ).toMap(),
//       );
//     }

//     for (final item in utils.expenseCategories) {
//       rows.add(
//         CategoryModel(
//           key: item.keyName,
//           iconCode: item.icon.codePoint,
//           colorValue: item.color.value,
//           isIncome: false,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ).toMap(),
//       );
//     }

//     await _db.insertBatch(DbConstants.tableCategories, rows);

//     print('✅ ${rows.length} categories seeded.');
//   }
// }
