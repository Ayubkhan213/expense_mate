import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';

import '../../data/models/transaction_model.dart';
import '../../data/models/enums.dart';

abstract class TransactionRepository {
  // CREATE
  // Future<String> createTransaction(TransactionModel transaction);

  // READ
  TransactionModel? getTransactionById(String id);

  List<TransactionModel> getAllTransactions();

  List<TransactionModel> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  List<TransactionModel> getTransactionsByType(TransactionType type);

  List<TransactionModel> getTransactionsByCategory(String categoryKey);

  // List<TransactionModel> getTransactionsByBudget(String budgetId);

  List<TransactionModel> getDebtTransactions();

  List<TransactionModel> getRecurringTransactions();

  List<TransactionModel> getRecentTransactions({int limit = 10});

  // UPDATE
  Future<void> updateTransaction(TransactionModel transaction);

  // DELETE
  Future<void> deleteTransaction(String id); // Soft delete
  Future<void> permanentlyDeleteTransaction(String id); // Hard delete

  // STATISTICS
  // double getTotalIncome({DateTime? startDate, DateTime? endDate});

  // double getTotalExpense({DateTime? startDate, DateTime? endDate});

  double getBalance({DateTime? startDate, DateTime? endDate});

  Future<TransactionResult> saveBudgetTransactionUseCase({
    required TransactionModel transaction,
    required BudgetModel budget,
  });
  Future<TransactionResult> saveNormalTransactionUseCase({
    required TransactionModel transaction,
  });
  Map<String, double> getCategoryBreakdown({
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Create a new debt
  Future<TransactionResult> createDebt(DebtModel debt);

  /// Get a debt by ID
  DebtModel? getDebtById(String id);

  /// Update a debt
  Future<void> updateDebt(DebtModel debt);

  /// Delete a debt
  Future<void> deleteDebt(String id);
  //get pure transcation
  // List<TransactionModel> getPureTransactions({int? limit});

  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment);
}
