import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:hive/hive.dart';

abstract class TransactionLocalDataSource {
  Future<TransactionResult> createTransaction(TransactionModel transaction);

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
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> permanentlyDeleteTransaction(String id);
  Future<TransactionResult> createDebt(DebtModel debt);

  DebtModel? getDebtById(String id);
  List<DebtModel> getAllDebts();
  Future<void> updateDebt(DebtModel debt);
  Future<void> deleteDebt(String id);
  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment);

  List<DebtPaymentModel> getPaymentsByDebtId(String debtId);

  List<DebtPaymentModel> getAllDebtPayments();
  Future<void> updateBudget(BudgetModel budget);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  Box<TransactionModel> get _box => HiveBoxManager.transactions;
  Box<DebtModel> get _debtBox => HiveBoxManager.debts;
  Box<DebtPaymentModel> get _debtpaymentBox => HiveBoxManager.debtPayments;
  Box<BudgetModel> get _budgetBox => HiveBoxManager.budgets;
  @override
  Future<TransactionResult> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      await _box.put(transaction.id, transaction);

      return TransactionResult(
        success: true,
        message: 'Transaction added successfully',
        transactionId: transaction.id,
      );
    } catch (e, stackTrace) {
      print('CreateTransaction error: $e');
      print(stackTrace);

      return TransactionResult(
        success: false,
        message: 'Failed to add transaction',
      );
    }
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _budgetBox.put(budget.id, budget);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  TransactionModel? getTransactionById(String id) {
    return _box.get(id);
  }

  @override
  List<TransactionModel> getAllTransactions() {
    return _box.values.where((t) => !t.isDeleted).toList();
  }

  @override
  List<TransactionModel> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _box.values
        .where(
          (t) =>
              !t.isDeleted &&
              t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
  }

  @override
  List<TransactionModel> getTransactionsByType(TransactionType type) {
    return _box.values.where((t) => !t.isDeleted && t.type == type).toList();
  }

  @override
  List<TransactionModel> getTransactionsByCategory(String categoryKey) {
    return _box.values
        .where(
          (t) =>
              !t.isDeleted &&
              t.items.any((item) => item.category == categoryKey),
        )
        .toList();
  }

  @override
  List<TransactionModel> getDebtTransactions() {
    return _box.values.where((t) => !t.isDeleted && t.isDebt).toList();
  }

  @override
  List<TransactionModel> getRecurringTransactions() {
    return _box.values.where((t) => !t.isDeleted && t.isRecurring).toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final transaction = _box.get(id);
    if (transaction != null) {
      final deleted = TransactionModel(
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
        isDeleted: true,
        budgetId: transaction.budgetId,
        userId: transaction.userId,
      );
      await _box.put(id, deleted);
    }
  }

  @override
  Future<void> permanentlyDeleteTransaction(String id) async {
    await _box.delete(id);
  }

  @override
  Future<TransactionResult> createDebt(DebtModel debt) async {
    try {
      await _debtBox.put(debt.id, debt);

      return TransactionResult(
        success: true,
        message: 'Debt created successfully',
        transactionId: debt.id,
      );
    } catch (e, st) {
      print('CreateDebt error: $e\n$st');
      return TransactionResult(
        success: false,
        message: 'Failed to create debt',
      );
    }
  }

  @override
  DebtModel? getDebtById(String id) {
    return _debtBox.get(id);
  }

  @override
  List<DebtModel> getAllDebts() {
    return _debtBox.values.toList();
  }

  @override
  Future<void> updateDebt(DebtModel debt) async {
    await _debtBox.put(debt.id, debt);
  }

  @override
  Future<void> deleteDebt(String id) async {
    await _debtBox.delete(id);
  }

  @override
  Future<TransactionResult> addDebtPayment(DebtPaymentModel payment) async {
    try {
      final debt = _debtBox.get(payment.debtId);

      if (debt == null) {
        return TransactionResult(success: false, message: 'Debt not found');
      }

      // Save payment
      await _debtpaymentBox.put(payment.id, payment);

      final newPaidAmount = debt.paidAmount + payment.amount;

      final updatedDebt = debt.copyWith(
        paidAmount: newPaidAmount,
        isReturned: newPaidAmount >= debt.totalAmount,
        updatedAt: DateTime.now(),
      );

      await _debtBox.put(updatedDebt.id, updatedDebt);

      return TransactionResult(
        success: true,
        message: 'Payment added successfully',
        transactionId: payment.transactionId,
      );
    } catch (e, st) {
      print('AddDebtPayment error: $e\n$st');
      return TransactionResult(
        success: false,
        message: 'Failed to add payment',
      );
    }
  }

  @override
  List<DebtPaymentModel> getPaymentsByDebtId(String debtId) {
    return _debtpaymentBox.values.where((p) => p.debtId == debtId).toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  @override
  List<DebtPaymentModel> getAllDebtPayments() {
    return _debtpaymentBox.values.toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }
}
