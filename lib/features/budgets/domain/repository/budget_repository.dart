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
