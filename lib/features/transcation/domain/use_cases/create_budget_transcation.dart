// // ============================================
// // 2. CREATE BUDGET TRANSACTION USE CASE
// // Path: lib/features/add_transaction/domain/usecases/create_budget_transaction.dart
// // ============================================

// import 'package:expense_mate/core/data/models/budget_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';
// import 'package:expense_mate/core/data/models/transaction_item_model.dart';
// import 'package:expense_mate/core/data/models/transaction_model.dart';
// import 'package:expense_mate/core/domain/repository/budget_repository.dart';
// import 'package:expense_mate/core/domain/repository/transcation_repository.dart';
// import 'package:uuid/uuid.dart';

// class CreateBudgetTransaction {
//   final TransactionRepository transactionRepository;
//   final BudgetRepository budgetRepository;
//   final Uuid _uuid = Uuid();

//   CreateBudgetTransaction({
//     required this.transactionRepository,
//     required this.budgetRepository,
//   });

//   Future<String> execute({
//     required String budgetId,
//     required TransactionType type,
//     required String categoryKey,
//     required double amount,
//     required PaymentMethod paymentMethod,
//     required DateTime date,
//     String? note,
//     String? attachmentPath,
//     List<String>? tags,
//   }) async {
//     // Validate
//     if (amount <= 0) {
//       throw Exception('Amount must be greater than 0');
//     }

//     final budgetResult = budgetRepository.getBudgetById(budgetId);

//     late final BudgetModel budget;

//     budgetResult.fold(
//       (failure) {
//         throw Exception(failure.message);
//       },
//       (data) {
//         if (data == null) {
//           throw Exception('Budget not found');
//         }
//         budget = data;
//       },
//     );

//     // Check if budget is active
//     if (!budget.isActive || budget.isArchived) {
//       throw Exception('Budget is not active');
//     }

//     // Check if budget is expired
//     if (budget.isExpired) {
//       throw Exception('Budget has expired');
//     }

//     // Check budget limit
//     final newSpentAmount = budget.spentAmount + amount;
//     if (newSpentAmount > budget.totalAmount) {
//       print('Warning: This transaction will exceed budget limit');
//     }

//     // Create transaction item
//     final item = TransactionItem(
//       category: categoryKey,
//       amount: amount,
//       note: note,
//     );

//     // Create transaction with budget link
//     final transaction = TransactionModel(
//       id: _uuid.v4(),
//       type: type,
//       items: [item],
//       totalAmount: amount,
//       paymentMethod: paymentMethod,
//       date: date,
//       isDebt: false,
//       isRecurring: false,
//       budgetId: budgetId, // Link to budget
//       attachmentPath: attachmentPath,
//       tags: tags,
//     );

//     // Save transaction
//     final transactionId = await transactionRepository.createTransaction(
//       transaction,
//     );

//     // Update budget
//     await budgetRepository.addTransactionToBudget(
//       budgetId,
//       transactionId,
//       amount,
//     );

//     return transactionId;
//   }
// }
