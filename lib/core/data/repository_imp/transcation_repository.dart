import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';

class TransactionRepositoryImp extends TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  // Constructor now requires data source
  TransactionRepositoryImp({required this.localDataSource});

  // @override
  // Future<String> createTransaction(TransactionModel transaction) async {
  //   return await localDataSource.createTransaction(transaction);
  // }

  @override
  TransactionModel? getTransactionById(String id) {
    return localDataSource.getTransactionById(id);
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

  @override
  List<TransactionModel> getTransactionsByBudget(String budgetId) {
    return localDataSource.getTransactionsByBudget(budgetId)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

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
    required TransactionModel transcationModel,
  }) async {
    return await localDataSource.createTransaction(transcationModel);
  }
}
