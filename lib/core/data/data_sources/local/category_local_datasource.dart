import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:spendio/core/database/sqflite_helper.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAll();
  Future<List<CategoryModel>> getIncome();
  Future<List<CategoryModel>> getExpense();
  Future<void> add(CategoryModel category);
  Future<void> update(CategoryModel category);
  Future<void> delete(CategoryModel category);
}

// ─────────────────────────────────────────────────────────────────────────────

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SqliteHelper _db = SqliteHelper.instance;

  @override
  Future<List<CategoryModel>> getAll() async {
    final rows = await _db.queryWhere(
      DbConstants.tableCategories,
      where: '${DbConstants.colIsActive} = ?',
      whereArgs: [1],
      orderBy: '${DbConstants.colCategoryKey} ASC',
    );
    return rows.map((r) => CategoryModel.fromMap(r)).toList();
  }

  @override
  Future<List<CategoryModel>> getIncome() async {
    final rows = await _db.queryWhere(
      DbConstants.tableCategories,
      where:
          '${DbConstants.colCategoryIsIncome} = ? '
          'AND ${DbConstants.colIsActive} = ?',
      whereArgs: [1, 1],
      orderBy: '${DbConstants.colCategoryKey} ASC',
    );
    return rows.map((r) => CategoryModel.fromMap(r)).toList();
  }

  @override
  Future<List<CategoryModel>> getExpense() async {
    final rows = await _db.queryWhere(
      DbConstants.tableCategories,
      where:
          '${DbConstants.colCategoryIsIncome} = ? '
          'AND ${DbConstants.colIsActive} = ?',
      whereArgs: [0, 1],
      orderBy: '${DbConstants.colCategoryKey} ASC',
    );
    return rows.map((r) => CategoryModel.fromMap(r)).toList();
  }

  @override
  Future<void> add(CategoryModel category) async {
    await _db.insert(
      DbConstants.tableCategories,
      CategoryModel.fromEntity(category).toMap(),
    );
  }

  @override
  Future<void> update(CategoryModel category) async {
    await _db.update(
      DbConstants.tableCategories,
      CategoryModel.fromEntity(category).toMap()
        ..[DbConstants.colUpdatedAt] = DateTime.now().toIso8601String(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> delete(CategoryModel category) async {
    // Soft-delete — keeps the row so existing transactions resolve their key
    await _db.update(
      DbConstants.tableCategories,
      {
        DbConstants.colIsActive: 0,
        DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DbConstants.colId} = ?',
      whereArgs: [category.id],
    );
  }
}
