import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:hive/hive.dart';

abstract class TransactionLocalDataSource {
  Future<String> createTransaction(TransactionModel transaction);
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
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> permanentlyDeleteTransaction(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  Box<TransactionModel> get _box => HiveBoxManager.transactions;

  @override
  Future<String> createTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
    return transaction.id;
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
  List<TransactionModel> getTransactionsByBudget(String budgetId) {
    return _box.values
        .where((t) => !t.isDeleted && t.budgetId == budgetId)
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
}
