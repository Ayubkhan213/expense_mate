// ============================================
// 3. CREATE DEBT TRANSACTION USE CASE
// Path: lib/features/add_transaction/domain/usecases/create_debt_transaction.dart
// ============================================

import 'package:expense_mate/core/domain/repository/debt_repository.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_item_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';

class CreateDebtTransaction {
  final TransactionRepository transactionRepository;
  final DebtRepository debtRepository;
  final Uuid _uuid = Uuid();

  CreateDebtTransaction({
    required this.transactionRepository,
    required this.debtRepository,
  });

  Future<CreateDebtTransactionResult> execute({
    required TransactionType type,
    required String categoryKey,
    required double amount,
    required PaymentMethod paymentMethod,
    required DateTime date,
    required DebtType debtType,
    required String personName,
    required DateTime expectedReturnDate,
    String? note,
    String? personPhone,
    String? personImage,
    String? attachmentPath,
    List<String>? tags,
  }) async {
    // Validate
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    if (personName.trim().isEmpty) {
      throw Exception('Person name is required');
    }

    if (expectedReturnDate.isBefore(date)) {
      throw Exception('Expected return date must be after transaction date');
    }

    // Validate debt type matches transaction type
    if (type == TransactionType.expense && debtType != DebtType.borrowed) {
      throw Exception('Expense transactions can only be "borrowed" debts');
    }
    if (type == TransactionType.income && debtType != DebtType.lent) {
      throw Exception('Income transactions can only be "lent" debts');
    }

    // Create transaction item
    final item = TransactionItem(
      category: categoryKey,
      amount: amount,
      note: note,
    );

    // Create transaction (first without debtId)
    final transactionId = _uuid.v4();
    final transaction = TransactionModel(
      id: transactionId,
      type: type,
      items: [item],
      totalAmount: amount,
      paymentMethod: paymentMethod,
      date: date,
      isDebt: true,
      isRecurring: false,
      attachmentPath: attachmentPath,
      tags: tags,
    );

    // Save transaction
    await transactionRepository.createTransaction(transaction);

    // Create debt record
    final debt = DebtModel(
      id: _uuid.v4(),
      transactionId: transactionId,
      personName: personName.trim(),
      totalAmount: amount,
      debtType: debtType,
      expectedReturnDate: expectedReturnDate,
      isReturned: false,
      paidAmount: 0.0,
      personPhone: personPhone,
      personImage: personImage,
    );

    // Save debt
    final debtId = await debtRepository.createDebt(debt);

    // Update transaction with debtId
    final updatedTransaction = TransactionModel(
      id: transaction.id,
      type: transaction.type,
      items: transaction.items,
      totalAmount: transaction.totalAmount,
      paymentMethod: transaction.paymentMethod,
      date: transaction.date,
      isDebt: true,
      debtId: debtId,
      isRecurring: transaction.isRecurring,
      attachmentPath: transaction.attachmentPath,
      tags: transaction.tags,
      createdAt: transaction.createdAt,
    );

    await transactionRepository.updateTransaction(updatedTransaction);

    return CreateDebtTransactionResult(
      transactionId: transactionId,
      debtId: debtId,
    );
  }
}

// Result class
class CreateDebtTransactionResult {
  final String transactionId;
  final String debtId;

  CreateDebtTransactionResult({
    required this.transactionId,
    required this.debtId,
  });
}
