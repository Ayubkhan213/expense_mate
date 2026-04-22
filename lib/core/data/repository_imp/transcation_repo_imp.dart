import 'package:spendio/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_result.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/domain/repository/sql/transcation_repository.dart';

class TransactionRepositoryImp extends TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImp({required this.localDataSource});

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS — READ
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<TransactionModel?> getTransactionById(String id) {
    return localDataSource.getTransactionById(id);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final list = await localDataSource.getAllTransactions();
    return list..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final list = await localDataSource.getTransactionsByDateRange(
      startDate,
      endDate,
    );
    return list..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(
    TransactionType type,
  ) async {
    final list = await localDataSource.getTransactionsByType(type);
    return list..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(
    String categoryKey,
  ) async {
    final list = await localDataSource.getTransactionsByCategory(categoryKey);
    return list..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getDebtTransactions() async {
    final list = await localDataSource.getDebtTransactions();
    return list..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getRecurringTransactions() async {
    final list = await localDataSource.getRecurringTransactions();
    return list..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    final list = await getAllTransactions();
    return list.take(limit).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS — WRITE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
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
      updatedAt: DateTime.now(),
      isDeleted: transaction.isDeleted,
      budgetId: transaction.budgetId,
      userId: transaction.userId,
    );
    await localDataSource.updateTransaction(updated);
  }

  @override
  Future<void> deleteTransaction(String id) =>
      localDataSource.deleteTransaction(id);

  @override
  Future<void> permanentlyDeleteTransaction(String id) =>
      localDataSource.permanentlyDeleteTransaction(id);

  // ═══════════════════════════════════════════════════════════════════════════
  // AGGREGATES
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Future<double> getTotalIncome({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await _transactionsForRange(
      startDate,
      endDate,
      TransactionType.income,
    );

    return transactions.fold<double>(
      0.0,
      (double sum, t) => sum + t.totalAmount,
    );
  }

  @override
  Future<double> getTotalExpense({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await _transactionsForRange(
      startDate,
      endDate,
      TransactionType.expense,
    );

    return transactions.fold<double>(
      0.0,
      (double sum, t) => sum + t.totalAmount,
    );
  }

  @override
  Future<double> getBalance({DateTime? startDate, DateTime? endDate}) async {
    final income = await getTotalIncome(startDate: startDate, endDate: endDate);
    final expense = await getTotalExpense(
      startDate: startDate,
      endDate: endDate,
    );
    return income - expense;
  }

  @override
  Future<Map<String, double>> getCategoryBreakdown({
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await _transactionsForRange(startDate, endDate, type);
    final Map<String, double> breakdown = {};
    for (final t in transactions) {
      for (final item in t.items) {
        breakdown[item.category] =
            (breakdown[item.category] ?? 0) + item.amount;
      }
    }
    return breakdown;
  }

  // ── private helper ─────────────────────────────────────────────────────────
  Future<List<TransactionModel>> _transactionsForRange(
    DateTime? startDate,
    DateTime? endDate,
    TransactionType type,
  ) async {
    if (startDate != null && endDate != null) {
      final list = await localDataSource.getTransactionsByDateRange(
        startDate,
        endDate,
      );
      return list.where((t) => t.type == type).toList();
    }
    return localDataSource.getTransactionsByType(type);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // USE-CASES  (orchestrated multi-step operations)
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<TransactionResult> saveBudgetTransactionUseCase({
    required TransactionModel transaction,
    required BudgetModel budget,
  }) async {
    try {
      // 1. Save transaction
      await localDataSource.createTransaction(transaction);

      // 2. Update budget spent amount
      final updatedBudgetEntity = budget.copyWith(
        spentAmount: budget.spentAmount + transaction.totalAmount,
        updatedAt: DateTime.now(),
      );

      final updatedBudget = BudgetModel.fromEntity(updatedBudgetEntity);

      await localDataSource.updateBudget(updatedBudget);

      return TransactionResult(
        success: true,
        message: 'Transaction added & budget updated',
        transactionId: transaction.id,
      );
    } catch (e, stack) {
      print('saveBudgetTransactionUseCase error: $e\n$stack');

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
      await localDataSource.createTransaction(transaction);
      return TransactionResult(
        success: true,
        message: 'Transaction added successfully',
        transactionId: transaction.id,
      );
    } catch (e, stack) {
      print('saveNormalTransactionUseCase error: $e\n$stack');
      return TransactionResult(
        success: false,
        message: 'Failed to save transaction',
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DEBTS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<TransactionResult> createDebt(DebtModel debt) =>
      localDataSource.createDebt(debt);

  @override
  Future<DebtModel?> getDebtById(String id) => localDataSource.getDebtById(id);

  @override
  Future<void> updateDebt(DebtModel debt) async {
    final updatedDebtEntity = debt.copyWith(updatedAt: DateTime.now());

    final updatedDebt = DebtModel.fromEntity(updatedDebtEntity);

    await localDataSource.updateDebt(updatedDebt);
  }

  @override
  Future<void> deleteDebt(String id) => localDataSource.deleteDebt(id);

  @override
  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment) =>
      localDataSource.addDebtPayment(payment);
}
