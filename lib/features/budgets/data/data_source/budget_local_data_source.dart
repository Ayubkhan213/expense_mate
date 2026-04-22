// import 'package:spendio/core/data/models/budget_model.dart';
// import 'package:spendio/core/data/models/enums.dart';
// import 'package:spendio/core/data/models/transaction_model.dart';
// import 'package:spendio/core/services/hive_box_manager.dart';
// import 'package:hive/hive.dart';

// import '../../../../core/data/models/budget_sql_model.dart';

// abstract class BudgetLocalDataSource {
//   List<TransactionModel> getTransactionsByBudget(String budgetId);
//   Future<String> createBudget(BudgetModel budget);
//   BudgetModel? getBudgetById(String id);
//   List<BudgetModel> getAllBudgets();
//   List<BudgetModel> getActiveBudgets();
//   List<BudgetModel> getArchivedBudgets();
//   List<BudgetModel> getBudgetsByType(BudgetType type);
//   List<BudgetModel> getOverBudgets();
//   List<BudgetModel> getExpiredBudgets();
//   Future<void> updateBudget(BudgetModel budget);
//   Future<void> addTransactionToBudget(
//     String budgetId,
//     String transactionId,
//     double amount,
//   );
//   Future<void> removeTransactionFromBudget(
//     String budgetId,
//     String transactionId,
//     double amount,
//   );
//   Future<void> archiveBudget(String id);
//   Future<void> deleteBudget(String id);
// }

// class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
//   Box<BudgetModel> get _box => HiveBoxManager.budgets;
//   Box<TransactionModel> get _transcationBox => HiveBoxManager.transactions;
//   @override
//   Future<String> createBudget(BudgetModel budget) async {
//     await _box.put(budget.id, budget);
//     return budget.id;
//   }

//   @override
//   BudgetModel? getBudgetById(String id) {
//     return _box.get(id);
//   }

//   @override
//   List<BudgetModel> getAllBudgets() {
//     return _box.values.toList();
//   }

//   @override
//   List<BudgetModel> getActiveBudgets() {
//     return _box.values
//         .where((b) => b.isActive && !b.isArchived && !b.isExpired)
//         .toList();
//   }

//   @override
//   List<BudgetModel> getArchivedBudgets() {
//     return _box.values.where((b) => b.isArchived).toList();
//   }

//   @override
//   List<BudgetModel> getBudgetsByType(BudgetType type) {
//     return _box.values.where((b) => b.type == type && !b.isArchived).toList();
//   }

//   @override
//   List<BudgetModel> getOverBudgets() {
//     return _box.values.where((b) => b.isOverBudget && !b.isArchived).toList();
//   }

//   @override
//   List<BudgetModel> getExpiredBudgets() {
//     return _box.values.where((b) => b.isExpired && !b.isArchived).toList();
//   }

//   @override
//   Future<void> updateBudget(BudgetModel budget) async {
//     final updated = BudgetModel(
//       id: budget.id,
//       name: budget.name,
//       type: budget.type,
//       totalAmount: budget.totalAmount,
//       spentAmount: budget.spentAmount,
//       startDate: budget.startDate,
//       endDate: budget.endDate,
//       transactionIds: budget.transactionIds,
//       category: budget.category,
//       icon: budget.icon,
//       colorCode: budget.colorCode,
//       isActive: budget.isActive,
//       isArchived: budget.isArchived,
//       createdAt: budget.createdAt,
//       updatedAt: DateTime.now(),
//     );
//     await _box.put(budget.id, updated);
//   }

//   @override
//   List<TransactionModel> getTransactionsByBudget(String budgetId) {
//     return _transcationBox.values
//         .where((t) => !t.isDeleted && t.budgetId == budgetId)
//         .toList();
//   }

//   @override
//   Future<void> addTransactionToBudget(
//     String budgetId,
//     String transactionId,
//     double amount,
//   ) async {
//     final budget = _box.get(budgetId);
//     if (budget != null) {
//       final updatedTransactionIds = List<String>.from(budget.transactionIds)
//         ..add(transactionId);

//       final updated = BudgetModel(
//         id: budget.id,
//         name: budget.name,
//         type: budget.type,
//         totalAmount: budget.totalAmount,
//         spentAmount: budget.spentAmount + amount,
//         startDate: budget.startDate,
//         endDate: budget.endDate,
//         transactionIds: updatedTransactionIds,
//         category: budget.category,
//         icon: budget.icon,
//         colorCode: budget.colorCode,
//         isActive: budget.isActive,
//         isArchived: budget.isArchived,
//         createdAt: budget.createdAt,
//         updatedAt: DateTime.now(),
//       );
//       await _box.put(budgetId, updated);
//     }
//   }

//   @override
//   Future<void> removeTransactionFromBudget(
//     String budgetId,
//     String transactionId,
//     double amount,
//   ) async {
//     final budget = _box.get(budgetId);
//     if (budget != null) {
//       final updatedTransactionIds = List<String>.from(budget.transactionIds)
//         ..remove(transactionId);

//       final updated = BudgetModel(
//         id: budget.id,
//         name: budget.name,
//         type: budget.type,
//         totalAmount: budget.totalAmount,
//         spentAmount: (budget.spentAmount - amount).clamp(0.0, double.infinity),
//         startDate: budget.startDate,
//         endDate: budget.endDate,
//         transactionIds: updatedTransactionIds,
//         category: budget.category,
//         icon: budget.icon,
//         colorCode: budget.colorCode,
//         isActive: budget.isActive,
//         isArchived: budget.isArchived,
//         createdAt: budget.createdAt,
//         updatedAt: DateTime.now(),
//       );
//       await _box.put(budgetId, updated);
//     }
//   }

//   @override
//   Future<void> archiveBudget(String id) async {
//     final budget = _box.get(id);
//     if (budget != null) {
//       final updated = BudgetModel(
//         id: budget.id,
//         name: budget.name,
//         type: budget.type,
//         totalAmount: budget.totalAmount,
//         spentAmount: budget.spentAmount,
//         startDate: budget.startDate,
//         endDate: budget.endDate,
//         transactionIds: budget.transactionIds,
//         category: budget.category,
//         icon: budget.icon,
//         colorCode: budget.colorCode,
//         isActive: false,
//         isArchived: true,
//         createdAt: budget.createdAt,
//         updatedAt: DateTime.now(),
//       );
//       await _box.put(id, updated);
//     }
//   }

//   @override
//   Future<void> deleteBudget(String id) async {
//     await _box.delete(id);
//   }
// }

// // // ==================== DATA LAYER ====================

// // // 1. Data Source (Local)
// // import 'package:spendio/core/data/models/budget_model.dart';

// // import 'package:spendio/core/data/models/transaction_model.dart';
// // import 'package:spendio/core/services/hive_box_manager.dart';

// // abstract class BudgetLocalDataSource {
// //   Future<List<BudgetModel>> getAllBudgets();
// //   Future<BudgetModel?> getBudgetById(String id);
// //   Future<void> createBudget(BudgetModel budget);
// //   Future<void> updateBudget(BudgetModel budget);
// //   Future<void> deleteBudget(String id);
// //   Future<List<TransactionModel>> getTransactionsForBudget(String budgetId);
// // }

// // class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
// //   @override
// //   Future<List<BudgetModel>> getAllBudgets() async {
// //     return HiveBoxManager.budgets.values.toList();
// //   }

// //   @override
// //   Future<BudgetModel?> getBudgetById(String id) async {
// //     return HiveBoxManager.budgets.get(id);
// //   }

// //   @override
// //   Future<void> createBudget(BudgetModel budget) async {
// //     await HiveBoxManager.budgets.put(budget.id, budget);
// //   }

// //   @override
// //   Future<void> updateBudget(BudgetModel budget) async {
// //     await HiveBoxManager.budgets.put(budget.id, budget);
// //   }

// //   @override
// //   Future<void> deleteBudget(String id) async {
// //     await HiveBoxManager.budgets.delete(id);
// //   }

// //   @override
// //   Future<List<TransactionModel>> getTransactionsForBudget(
// //     String budgetId,
// //   ) async {
// //     final budget = await getBudgetById(budgetId);
// //     if (budget == null) return [];

// //     return budget.transactionIds
// //         .map((id) => HiveBoxManager.transactions.get(id))
// //         .whereType<TransactionModel>()
// //         .toList();
// //   }
// // }
