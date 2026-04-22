import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_result.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';

abstract class TransactionRepository {
  // ═══════════════════════════════════
  // TRANSACTIONS — READ
  // ═══════════════════════════════════

  Future<TransactionModel?> getTransactionById(String id);

  Future<List<TransactionModel>> getAllTransactions();

  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  Future<List<TransactionModel>> getTransactionsByType(TransactionType type);

  Future<List<TransactionModel>> getTransactionsByCategory(String categoryKey);

  Future<List<TransactionModel>> getDebtTransactions();

  Future<List<TransactionModel>> getRecurringTransactions();

  Future<List<TransactionModel>> getRecentTransactions({int limit = 10});

  // ═══════════════════════════════════
  // TRANSACTIONS — WRITE
  // ═══════════════════════════════════

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);

  Future<void> permanentlyDeleteTransaction(String id);

  // ═══════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════

  Future<double> getTotalIncome({DateTime? startDate, DateTime? endDate});

  Future<double> getTotalExpense({DateTime? startDate, DateTime? endDate});

  Future<double> getBalance({DateTime? startDate, DateTime? endDate});

  Future<Map<String, double>> getCategoryBreakdown({
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  });

  // ═══════════════════════════════════
  // USE CASES
  // ═══════════════════════════════════

  Future<TransactionResult> saveBudgetTransactionUseCase({
    required TransactionModel transaction,
    required BudgetModel budget,
  });

  Future<TransactionResult> saveNormalTransactionUseCase({
    required TransactionModel transaction,
  });

  // ═══════════════════════════════════
  // DEBTS
  // ═══════════════════════════════════

  Future<TransactionResult> createDebt(DebtModel debt);

  Future<DebtModel?> getDebtById(String id);

  Future<void> updateDebt(DebtModel debt);

  Future<void> deleteDebt(String id);

  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment);
}
