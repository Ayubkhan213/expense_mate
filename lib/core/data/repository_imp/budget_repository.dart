import 'package:expense_mate/core/domain/repository/budget_repository.dart';
import 'package:expense_mate/core/data/data_sources/local/budget_local_data_source.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';

class BudgetRepositoryImp extends BudgetRepository {
  final BudgetLocalDataSource localDataSource;

  BudgetRepositoryImp({required this.localDataSource});
  @override
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget) async {
    try {
      await localDataSource.createBudget(budget);
      return Right(budget);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Either<Failure, List<BudgetModel>> getAllBudgets() {
    try {
      final budgets = localDataSource.getAllBudgets()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(budgets);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Either<Failure, BudgetModel?> getBudgetById(String id) {
    try {
      return Right(localDataSource.getBudgetById(id));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBudget(BudgetModel budget) async {
    try {
      await localDataSource.updateBudget(budget);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await localDataSource.deleteBudget(id);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  List<BudgetModel> getActiveBudgets() {
    return localDataSource.getActiveBudgets()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
  }

  @override
  List<BudgetModel> getArchivedBudgets() {
    return localDataSource.getArchivedBudgets()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  List<BudgetModel> getBudgetsByType(BudgetType type) {
    return localDataSource.getBudgetsByType(type)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  List<BudgetModel> getOverBudgets() {
    return localDataSource.getOverBudgets();
  }

  @override
  List<BudgetModel> getExpiredBudgets() {
    return localDataSource.getExpiredBudgets();
  }

  @override
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) async {
    await localDataSource.addTransactionToBudget(
      budgetId,
      transactionId,
      amount,
    );
  }

  @override
  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) async {
    await localDataSource.removeTransactionFromBudget(
      budgetId,
      transactionId,
      amount,
    );
  }

  @override
  Future<void> archiveBudget(String id) async {
    await localDataSource.archiveBudget(id);
  }

  @override
  double getTotalBudgeted() {
    return localDataSource.getActiveBudgets().fold(
      0.0,
      (sum, b) => sum + b.totalAmount,
    );
  }

  @override
  double getTotalSpent() {
    return localDataSource.getActiveBudgets().fold(
      0.0,
      (sum, b) => sum + b.spentAmount,
    );
  }

  @override
  double getTotalRemaining() {
    return getTotalBudgeted() - getTotalSpent();
  }

  @override
  int getActiveBudgetCount() {
    return localDataSource.getActiveBudgets().length;
  }
}
