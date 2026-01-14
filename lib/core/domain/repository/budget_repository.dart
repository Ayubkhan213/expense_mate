import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';

abstract class BudgetRepository {
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget);
  Either<Failure, List<BudgetModel>> getAllBudgets();
  Either<Failure, BudgetModel?> getBudgetById(String id);
  Future<Either<Failure, void>> updateBudget(BudgetModel budget);
  Future<Either<Failure, void>> deleteBudget(String id);

  List<BudgetModel> getActiveBudgets();

  List<BudgetModel> getArchivedBudgets();

  List<BudgetModel> getBudgetsByType(BudgetType type);

  List<BudgetModel> getOverBudgets();

  List<BudgetModel> getExpiredBudgets();

  // Budget ↔ Transaction
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  );

  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  );

  // Archive
  Future<void> archiveBudget(String id);

  // Statistics
  double getTotalBudgeted();

  double getTotalSpent();

  double getTotalRemaining();

  int getActiveBudgetCount();
}
