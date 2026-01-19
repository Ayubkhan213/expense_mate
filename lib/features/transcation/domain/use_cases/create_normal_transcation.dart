// // ============================================
// // 1. CREATE NORMAL TRANSACTION USE CASE
// // Path: lib/features/add_transaction/domain/usecases/create_normal_transaction.dart
// // ============================================

// import 'package:expense_mate/core/domain/repository/transcation_repository.dart';
// import 'package:uuid/uuid.dart';
// import 'package:expense_mate/core/data/models/transaction_model.dart';
// import 'package:expense_mate/core/data/models/transaction_item_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';

// class CreateNormalTransaction {
//   final TransactionRepository repository;
//   final Uuid _uuid = Uuid();

//   CreateNormalTransaction({required this.repository});

//   Future<String> execute({
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

//     // Create transaction item
//     final item = TransactionItem(
//       category: categoryKey,
//       amount: amount,
//       note: note,
//     );

//     // Create transaction
//     final transaction = TransactionModel(
//       id: _uuid.v4(),
//       type: type,
//       items: [item],
//       totalAmount: amount,
//       paymentMethod: paymentMethod,
//       date: date,
//       isDebt: false,
//       isRecurring: false,
//       attachmentPath: attachmentPath,
//       tags: tags,
//     );

//     // Save to repository
//     return await repository.createTransaction(transaction);
//   }
// }
