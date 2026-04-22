import 'package:spendio/core/data/data_sources/local/category_local_datasource.dart';
import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/core/domain/repository/sql/category_repository.dart';

class CategoryRepositoryImp extends CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImp({required this.localDataSource});

  @override
  Future<List<CategoryModel>> getAll() => localDataSource.getAll();

  @override
  Future<List<CategoryModel>> getIncome() => localDataSource.getIncome();

  @override
  Future<List<CategoryModel>> getExpense() => localDataSource.getExpense();

  @override
  Future<void> add(CategoryModel category) => localDataSource.add(category);

  @override
  Future<void> update(CategoryModel category) =>
      localDataSource.update(category);

  @override
  Future<void> delete(CategoryModel category) =>
      localDataSource.delete(category);
}
