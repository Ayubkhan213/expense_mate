import 'package:expense_mate/core/domain/repository/category_repository.dart';
import 'package:hive/hive.dart';
import '../../models/category_hive_model.dart';

class CategoryRepositoryImp extends CategoryRepository {
  static const String _boxName = 'categories';

  Box<CategoryHiveModel> get _box => Hive.box<CategoryHiveModel>(_boxName);
  @override
  // READ
  List<CategoryHiveModel> getAll() {
    return _box.values.toList();
  }

  @override
  List<CategoryHiveModel> getIncome() {
    return _box.values.where((e) => e.isIncome).toList();
  }

  @override
  List<CategoryHiveModel> getExpense() {
    return _box.values.where((e) => !e.isIncome).toList();
  }

  @override
  // CREATE
  Future<void> add(CategoryHiveModel category) async {
    await _box.add(category);
  }

  @override
  // UPDATE
  Future<void> update(CategoryHiveModel category) async {
    await category.save(); // HiveObject power
  }

  @override
  //  DELETE
  Future<void> delete(CategoryHiveModel category) async {
    await category.delete();
  }
}
