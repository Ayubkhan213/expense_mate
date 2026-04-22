import 'package:spendio/core/data/models/category_model.dart';

abstract class CategoryRepository {
  // READ
  Future<List<CategoryModel>> getAll();

  Future<List<CategoryModel>> getIncome();

  Future<List<CategoryModel>> getExpense();

  // CREATE
  Future<void> add(CategoryModel category);

  // UPDATE
  Future<void> update(CategoryModel category);

  //  DELETE
  Future<void> delete(CategoryModel category);
}
