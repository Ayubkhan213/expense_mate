import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';

class TransactionRepositoryImp extends TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  // Constructor now requires data source
  TransactionRepositoryImp({required this.localDataSource});

  @override
  TransactionModel? getTransactionById(String id) {
    return localDataSource.getTransactionById(id);
  }

  @override
  List<TransactionModel> getPureTransactions({int? limit}) {
    final list =
        localDataSource
            .getAllTransactions()
            .where((t) => !t.isDebt && !t.isRecurring)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    if (limit != null) {
      return list.take(limit).toList();
    }

    return list;
  }

  @override
  List<TransactionModel> getAllTransactions() {
    // Data source gets data, repository handles sorting
    return localDataSource.getAllTransactions()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<TransactionModel> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return localDataSource.getTransactionsByDateRange(startDate, endDate)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<TransactionModel> getTransactionsByType(TransactionType type) {
    return localDataSource.getTransactionsByType(type)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<TransactionModel> getTransactionsByCategory(String categoryKey) {
    return localDataSource.getTransactionsByCategory(categoryKey)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // @override
  // List<TransactionModel> getTransactionsByBudget(String budgetId) {
  //   return localDataSource.getTransactionsByBudget(budgetId)
  //     ..sort((a, b) => b.date.compareTo(a.date));
  // }

  @override
  List<TransactionModel> getDebtTransactions() {
    return localDataSource.getDebtTransactions()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<TransactionModel> getRecurringTransactions() {
    return localDataSource.getRecurringTransactions()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<TransactionModel> getRecentTransactions({int limit = 10}) {
    return (getAllTransactions()..take(limit)).toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    // Repository can add business logic like updating timestamp
    final updated = TransactionModel(
      id: transaction.id,
      type: transaction.type,
      items: transaction.items,
      totalAmount: transaction.totalAmount,
      paymentMethod: transaction.paymentMethod,
      date: transaction.date,
      isDebt: transaction.isDebt,
      debtId: transaction.debtId,
      tags: transaction.tags,
      attachmentPath: transaction.attachmentPath,
      isRecurring: transaction.isRecurring,
      createdAt: transaction.createdAt,
      updatedAt: DateTime.now(), // Business logic: update timestamp
      isDeleted: transaction.isDeleted,
      budgetId: transaction.budgetId,
      userId: transaction.userId,
    );
    await localDataSource.updateTransaction(updated);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localDataSource.deleteTransaction(id);
  }

  @override
  Future<void> permanentlyDeleteTransaction(String id) async {
    await localDataSource.permanentlyDeleteTransaction(id);
  }

  @override
  double getTotalIncome({DateTime? startDate, DateTime? endDate}) {
    List<TransactionModel> transactions;

    if (startDate != null && endDate != null) {
      transactions = localDataSource
          .getTransactionsByDateRange(startDate, endDate)
          .where((t) => t.type == TransactionType.income)
          .toList();
    } else {
      transactions = localDataSource.getTransactionsByType(
        TransactionType.income,
      );
    }

    return transactions.fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  @override
  double getTotalExpense({DateTime? startDate, DateTime? endDate}) {
    List<TransactionModel> transactions;

    if (startDate != null && endDate != null) {
      transactions = localDataSource
          .getTransactionsByDateRange(startDate, endDate)
          .where((t) => t.type == TransactionType.expense)
          .toList();
    } else {
      transactions = localDataSource.getTransactionsByType(
        TransactionType.expense,
      );
    }

    return transactions.fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  @override
  double getBalance({DateTime? startDate, DateTime? endDate}) {
    return getTotalIncome(startDate: startDate, endDate: endDate) -
        getTotalExpense(startDate: startDate, endDate: endDate);
  }

  @override
  Map<String, double> getCategoryBreakdown({
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    List<TransactionModel> transactions;

    if (startDate != null && endDate != null) {
      transactions = localDataSource
          .getTransactionsByDateRange(startDate, endDate)
          .where((t) => t.type == type)
          .toList();
    } else {
      transactions = localDataSource.getTransactionsByType(type);
    }

    final Map<String, double> breakdown = {};

    for (var transaction in transactions) {
      for (var item in transaction.items) {
        breakdown[item.category] =
            (breakdown[item.category] ?? 0) + item.amount;
      }
    }

    return breakdown;
  }

  @override
  Future<TransactionResult> saveBudgetTransactionUseCase({
    required TransactionModel transaction,
    required BudgetModel budget,
  }) async {
    try {
      // 1️⃣ Save transaction
      await localDataSource.createTransaction(transaction);

      // 2️⃣ Update budget values
      final updatedBudget = BudgetModel(
        id: budget.id,
        name: budget.name,
        type: budget.type,
        totalAmount: budget.totalAmount,
        spentAmount: budget.spentAmount + transaction.totalAmount,
        startDate: budget.startDate,
        endDate: budget.endDate,
        transactionIds: [...budget.transactionIds, transaction.id],
        category: budget.category,
        icon: budget.icon,
        colorCode: budget.colorCode,
        isActive: budget.isActive,
        isArchived: budget.isArchived,
        userId: budget.userId,
        updatedAt: DateTime.now(),
        createdAt: budget.createdAt,
      );

      // 3️⃣ Save updated budget
      await localDataSource.updateBudget(updatedBudget);

      return TransactionResult(
        success: true,
        message: 'Transaction added & budget updated',
        transactionId: transaction.id,
      );
    } catch (e, stack) {
      print('SaveBudgetTransaction error: $e');
      print(stack);

      return TransactionResult(
        success: false,
        message: 'Failed to save transaction',
      );
    }
  }

  @override
  Future<TransactionResult> saveNormalTransactionUseCase({
    required TransactionModel transaction,
  }) async {
    try {
      // 1️ Save transaction
      await localDataSource.createTransaction(transaction);

      return TransactionResult(
        success: true,
        message: 'Transaction added & budget updated',
        transactionId: transaction.id,
      );
    } catch (e, stack) {
      print('SaveBudgetTransaction error: $e');
      print(stack);

      return TransactionResult(
        success: false,
        message: 'Failed to save transaction',
      );
    }
  }

  @override
  Future<TransactionResult> createDebt(DebtModel debt) async {
    return await localDataSource.createDebt(debt);
  }

  @override
  DebtModel? getDebtById(String id) {
    return localDataSource.getDebtById(id);
  }

  // @override
  // List<DebtModel> getAllDebts() {
  //   // You can sort by creation date if needed
  //   final debts = localDataSource.getAllDebts();
  //   debts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  //   return debts;
  // }

  @override
  Future<void> updateDebt(DebtModel debt) async {
    // Add business logic: update timestamp, validation, etc.
    final updatedDebt = DebtModel(
      id: debt.id,
      transactionId: debt.transactionId,
      personName: debt.personName,
      totalAmount: debt.totalAmount,
      debtType: debt.debtType,
      expectedReturnDate: debt.expectedReturnDate,
      isReturned: debt.isReturned,
      paymentIds: debt.paymentIds,
      paidAmount: debt.paidAmount,
      createdAt: debt.createdAt,
      updatedAt: DateTime.now(), // Update timestamp
      personPhone: debt.personPhone,
      personImage: debt.personImage,
    );
    await localDataSource.updateDebt(updatedDebt);
  }

  @override
  Future<void> deleteDebt(String id) async {
    await localDataSource.deleteDebt(id);
  }

  @override
  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment) {
    return localDataSource.addDebtPayment(payment);
  }
}
