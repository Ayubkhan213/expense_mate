import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/error/failure.dart';
import 'package:spendio/core/utils/either.dart';
import 'package:spendio/features/budgets/data/data_source/sql/budget_local_datasource.dart';
import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';

import '../../../../core/data/models/transcation_sql_model.dart';

class BudgetRepositoryImp extends BudgetRepository {
  final BudgetLocalDataSource localDataSource;

  BudgetRepositoryImp({required this.localDataSource});

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget) async {
    try {
      await localDataSource.createBudget(budget);
      return Right(budget);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // READ
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<BudgetModel>>> getAllBudgets() async {
    try {
      final list = await localDataSource.getAllBudgets();
      return Right(list..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<BudgetModel?> getBudgetById(String id) =>
      localDataSource.getBudgetById(id);

  @override
  Future<List<BudgetModel>> getActiveBudgets() async {
    final list = await localDataSource.getActiveBudgets();
    return list..sort((a, b) => a.endDate.compareTo(b.endDate));
  }

  @override
  Future<List<BudgetModel>> getArchivedBudgets() async {
    final list = await localDataSource.getArchivedBudgets();
    return list..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<BudgetModel>> getBudgetsByType(BudgetType type) async {
    final list = await localDataSource.getBudgetsByType(type);
    return list..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<BudgetModel>> getOverBudgets() =>
      localDataSource.getOverBudgets();

  @override
  Future<List<BudgetModel>> getExpiredBudgets() =>
      localDataSource.getExpiredBudgets();

  @override
  Future<List<TransactionModel>> getTransactionsByBudget(
    String budgetId,
  ) async {
    final list = await localDataSource.getTransactionsByBudget(budgetId);
    return list..sort((a, b) => b.date.compareTo(a.date));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AGGREGATES
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<double> getTotalBudgeted() async {
    final list = await localDataSource.getActiveBudgets();
    return list.fold<double>(0, (sum, b) => sum + b.totalAmount);
  }

  @override
  Future<double> getTotalSpent() async {
    final list = await localDataSource.getActiveBudgets();
    return list.fold<double>(0, (sum, b) => sum + b.spentAmount);
  }

  @override
  Future<double> getTotalRemaining() async {
    return await getTotalBudgeted() - await getTotalSpent();
  }

  @override
  Future<int> getActiveBudgetCount() async {
    final list = await localDataSource.getActiveBudgets();
    return list.length;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE
  // ═══════════════════════════════════════════════════════════════════════════

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
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) => localDataSource.addTransactionToBudget(budgetId, transactionId, amount);

  @override
  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) => localDataSource.removeTransactionFromBudget(
    budgetId,
    transactionId,
    amount,
  );

  @override
  Future<void> archiveBudget(String id) => localDataSource.archiveBudget(id);

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await localDataSource.deleteBudget(id);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
