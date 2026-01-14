// import 'package:expense_mate/core/data/models/budget_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';
// import 'package:expense_mate/core/data/models/transaction_model.dart';
// import 'package:expense_mate/core/error/failure.dart';
// import 'package:expense_mate/core/services/hive_box_manager.dart';
// import 'package:expense_mate/core/utils/either.dart';
// import 'package:expense_mate/features/budgets/data/data_source/budget_local_data_source.dart';
// import 'package:expense_mate/features/budgets/domain/repository/budget_repository.dart';

// class BudgetRepositoryImpl implements BudgetRepository {
//   final BudgetLocalDataSource localDataSource;

//   BudgetRepositoryImpl(this.localDataSource);

//   @override
//   Future<Either<Failure, List<BudgetModel>>> getAllBudgets() async {
//     try {
//       final budgets = await localDataSource.getAllBudgets();
//       return Right(budgets);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget) async {
//     try {
//       await localDataSource.createBudget(budget);
//       return Right(budget);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, BudgetModel>> updateBudget(BudgetModel budget) async {
//     try {
//       await localDataSource.updateBudget(budget);
//       return Right(budget);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteBudget(String id) async {
//     try {
//       final budget = await localDataSource.getBudgetById(id);
//       if (budget == null) {
//         return Left(CacheFailure('Budget not found'));
//       }

//       // Unlink all transactions
//       for (final transactionId in budget.transactionIds) {
//         final transaction = HiveBoxManager.transactions.get(transactionId);
//         if (transaction != null) {
//           final updated = TransactionModel(
//             id: transaction.id,
//             type: transaction.type,
//             items: transaction.items,
//             totalAmount: transaction.totalAmount,
//             paymentMethod: transaction.paymentMethod,
//             date: transaction.date,
//             isDebt: transaction.isDebt,
//             debtId: transaction.debtId,
//             tags: transaction.tags,
//             attachmentPath: transaction.attachmentPath,
//             isRecurring: transaction.isRecurring,
//             createdAt: transaction.createdAt,
//             updatedAt: DateTime.now(),
//             isDeleted: transaction.isDeleted,
//             budgetId: null,
//             userId: transaction.userId,
//           );
//           await HiveBoxManager.transactions.put(transactionId, updated);
//         }
//       }

//       await localDataSource.deleteBudget(id);
//       return Right(null);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> linkTransaction(
//     String budgetId,
//     String transactionId,
//   ) async {
//     try {
//       final budget = await localDataSource.getBudgetById(budgetId);
//       if (budget == null) return Left(CacheFailure('Budget not found'));

//       final transaction = HiveBoxManager.transactions.get(transactionId);
//       if (transaction == null)
//         return Left(CacheFailure('Transaction not found'));

//       // Update budget
//       final updatedTransactionIds = List<String>.from(budget.transactionIds);
//       if (!updatedTransactionIds.contains(transactionId)) {
//         updatedTransactionIds.add(transactionId);
//       }

//       final updatedBudget = BudgetModel(
//         id: budget.id,
//         name: budget.name,
//         type: budget.type,
//         totalAmount: budget.totalAmount,
//         spentAmount: budget.spentAmount + transaction.totalAmount,
//         startDate: budget.startDate,
//         endDate: budget.endDate,
//         transactionIds: updatedTransactionIds,
//         category: budget.category,
//         icon: budget.icon,
//         colorCode: budget.colorCode,
//         isActive: budget.isActive,
//         isArchived: budget.isArchived,
//         createdAt: budget.createdAt,
//         userId: budget.userId,
//         updatedAt: DateTime.now(),
//       );

//       await localDataSource.updateBudget(updatedBudget);

//       // Update transaction
//       final updatedTransaction = TransactionModel(
//         id: transaction.id,
//         type: transaction.type,
//         items: transaction.items,
//         totalAmount: transaction.totalAmount,
//         paymentMethod: transaction.paymentMethod,
//         date: transaction.date,
//         isDebt: transaction.isDebt,
//         debtId: transaction.debtId,
//         tags: transaction.tags,
//         attachmentPath: transaction.attachmentPath,
//         isRecurring: transaction.isRecurring,
//         createdAt: transaction.createdAt,
//         updatedAt: DateTime.now(),
//         isDeleted: transaction.isDeleted,
//         budgetId: budgetId,
//         userId: transaction.userId,
//       );
//       await HiveBoxManager.transactions.put(transactionId, updatedTransaction);

//       return Right(null);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> unlinkTransaction(
//     String budgetId,
//     String transactionId,
//   ) async {
//     try {
//       final budget = await localDataSource.getBudgetById(budgetId);
//       if (budget == null) return Left(CacheFailure('Budget not found'));

//       final transaction = HiveBoxManager.transactions.get(transactionId);
//       if (transaction == null)
//         return Left(CacheFailure('Transaction not found'));

//       // Update budget
//       final updatedTransactionIds = List<String>.from(budget.transactionIds)
//         ..remove(transactionId);

//       final updatedBudget = BudgetModel(
//         id: budget.id,
//         name: budget.name,
//         type: budget.type,
//         totalAmount: budget.totalAmount,
//         spentAmount: (budget.spentAmount - transaction.totalAmount).clamp(
//           0,
//           double.infinity,
//         ),
//         startDate: budget.startDate,
//         endDate: budget.endDate,
//         transactionIds: updatedTransactionIds,
//         category: budget.category,
//         icon: budget.icon,
//         colorCode: budget.colorCode,
//         isActive: budget.isActive,
//         isArchived: budget.isArchived,
//         createdAt: budget.createdAt,
//         userId: budget.userId,
//         updatedAt: DateTime.now(),
//       );

//       await localDataSource.updateBudget(updatedBudget);

//       // Update transaction
//       final updatedTransaction = TransactionModel(
//         id: transaction.id,
//         type: transaction.type,
//         items: transaction.items,
//         totalAmount: transaction.totalAmount,
//         paymentMethod: transaction.paymentMethod,
//         date: transaction.date,
//         isDebt: transaction.isDebt,
//         debtId: transaction.debtId,
//         tags: transaction.tags,
//         attachmentPath: transaction.attachmentPath,
//         isRecurring: transaction.isRecurring,
//         createdAt: transaction.createdAt,
//         updatedAt: DateTime.now(),
//         isDeleted: transaction.isDeleted,
//         budgetId: null,
//         userId: transaction.userId,
//       );
//       await HiveBoxManager.transactions.put(transactionId, updatedTransaction);

//       return Right(null);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, double>> calculateBudgetSpending(
//     String budgetId,
//   ) async {
//     try {
//       final transactions = await localDataSource.getTransactionsForBudget(
//         budgetId,
//       );

//       final totalSpent = transactions
//           .where((t) => t.type == TransactionType.expense && !t.isDeleted)
//           .fold<double>(0, (sum, t) => sum + t.totalAmount);

//       return Right(totalSpent);
//     } catch (e) {
//       return Left(CacheFailure(e.toString()));
//     }
//   }
// }
