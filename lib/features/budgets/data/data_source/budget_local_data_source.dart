// // ==================== DATA LAYER ====================

// // 1. Data Source (Local)
// import 'package:expense_mate/core/data/models/budget_model.dart';

// import 'package:expense_mate/core/data/models/transaction_model.dart';
// import 'package:expense_mate/core/services/hive_box_manager.dart';

// abstract class BudgetLocalDataSource {
//   Future<List<BudgetModel>> getAllBudgets();
//   Future<BudgetModel?> getBudgetById(String id);
//   Future<void> createBudget(BudgetModel budget);
//   Future<void> updateBudget(BudgetModel budget);
//   Future<void> deleteBudget(String id);
//   Future<List<TransactionModel>> getTransactionsForBudget(String budgetId);
// }

// class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
//   @override
//   Future<List<BudgetModel>> getAllBudgets() async {
//     return HiveBoxManager.budgets.values.toList();
//   }

//   @override
//   Future<BudgetModel?> getBudgetById(String id) async {
//     return HiveBoxManager.budgets.get(id);
//   }

//   @override
//   Future<void> createBudget(BudgetModel budget) async {
//     await HiveBoxManager.budgets.put(budget.id, budget);
//   }

//   @override
//   Future<void> updateBudget(BudgetModel budget) async {
//     await HiveBoxManager.budgets.put(budget.id, budget);
//   }

//   @override
//   Future<void> deleteBudget(String id) async {
//     await HiveBoxManager.budgets.delete(id);
//   }

//   @override
//   Future<List<TransactionModel>> getTransactionsForBudget(
//     String budgetId,
//   ) async {
//     final budget = await getBudgetById(budgetId);
//     if (budget == null) return [];

//     return budget.transactionIds
//         .map((id) => HiveBoxManager.transactions.get(id))
//         .whereType<TransactionModel>()
//         .toList();
//   }
// }
