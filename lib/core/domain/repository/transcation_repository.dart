import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';

import '../../data/models/transaction_model.dart';
import '../../data/models/enums.dart';

abstract class TransactionRepository {
  // CREATE
  Future<String> createTransaction(TransactionModel transaction);

  // READ
  TransactionModel? getTransactionById(String id);

  List<TransactionModel> getAllTransactions();

  List<TransactionModel> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  List<TransactionModel> getTransactionsByType(TransactionType type);

  List<TransactionModel> getTransactionsByCategory(String categoryKey);

  List<TransactionModel> getTransactionsByBudget(String budgetId);

  List<TransactionModel> getDebtTransactions();

  List<TransactionModel> getRecurringTransactions();

  List<TransactionModel> getRecentTransactions({int limit = 10});

  // UPDATE
  Future<void> updateTransaction(TransactionModel transaction);

  // DELETE
  Future<void> deleteTransaction(String id); // Soft delete
  Future<void> permanentlyDeleteTransaction(String id); // Hard delete

  // STATISTICS
  double getTotalIncome({DateTime? startDate, DateTime? endDate});

  double getTotalExpense({DateTime? startDate, DateTime? endDate});

  double getBalance({DateTime? startDate, DateTime? endDate});

  Map<String, double> getCategoryBreakdown({
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  });
}
