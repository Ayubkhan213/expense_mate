import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';

abstract class BudgetRepository {
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget);
  Either<Failure, List<BudgetModel>> getAllBudgets();

  Future<Either<Failure, void>> updateBudget(BudgetModel budget);
  Future<Either<Failure, void>> deleteBudget(String id);

  List<BudgetModel> getActiveBudgets();

  List<BudgetModel> getArchivedBudgets();

  List<BudgetModel> getBudgetsByType(BudgetType type);

  List<BudgetModel> getOverBudgets();
  BudgetModel? getBudgetById(String id);

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
  List<TransactionModel> getTransactionsByBudget(String budgetId);

  // Archive
  Future<void> archiveBudget(String id);

  // Statistics
  double getTotalBudgeted();

  double getTotalSpent();

  double getTotalRemaining();

  int getActiveBudgetCount();
}

// // 2. Repository
// import 'package:expense_mate/core/data/models/budget_model.dart';
// import 'package:expense_mate/core/error/failure.dart';
// import 'package:expense_mate/core/utils/either.dart';

// abstract class BudgetRepository {
//   Future<Either<Failure, List<BudgetModel>>> getAllBudgets();
//   Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget);
//   Future<Either<Failure, BudgetModel>> updateBudget(BudgetModel budget);
//   Future<Either<Failure, void>> deleteBudget(String id);
//   Future<Either<Failure, void>> linkTransaction(
//     String budgetId,
//     String transactionId,
//   );
//   Future<Either<Failure, void>> unlinkTransaction(
//     String budgetId,
//     String transactionId,
//   );
//   Future<Either<Failure, double>> calculateBudgetSpending(String budgetId);
// }
