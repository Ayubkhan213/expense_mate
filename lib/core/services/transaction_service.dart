import 'package:hive/hive.dart';
import '../data/models/transaction_model.dart';
import '../data/models/debt_model.dart';
import '../data/models/debt_payment_model.dart';
import '../data/models/budget_model.dart';
import '../data/models/recurring_transaction_model.dart';
import '../data/models/enums.dart';
import 'hive_initializer.dart';

class TransactionService {
  final _transactionBox = Hive.box<TransactionModel>(
    HiveInitializer.transactionBox,
  );

  final _debtBox = Hive.box<DebtModel>(HiveInitializer.debtBox);

  final _debtPaymentBox = Hive.box<DebtPaymentModel>(
    HiveInitializer.debtPaymentBox,
  );

  final _budgetBox = Hive.box<BudgetModel>(HiveInitializer.budgetBox);

  final _recurringBox = Hive.box<RecurringTransactionModel>(
    HiveInitializer.recurringTransactionBox,
  );

  // ================= ADD TRANSACTION =================

  // Future<void> addTransaction({
  //   required TransactionModel transaction,
  //   DebtModel? debt,
  // }) async {
  //   await _transactionBox.put(transaction.id, transaction);

  //   // If it's a debt transaction, save the debt
  //   if (debt != null) {
  //     await _debtBox.put(debt.id, debt);
  //   }

  //   // Update budget if linked
  //   if (transaction.budgetId != null) {
  //     await _updateBudgetSpent(transaction.budgetId!, transaction.totalAmount);
  //   }
  // }

  // ================= UPDATE TRANSACTION =================

  Future<void> updateTransaction(TransactionModel transaction) async {
    await transaction.save();
  }

  Future<void> updateDebt(DebtModel debt) async {
    await debt.save();
  }

  // ================= DELETE TRANSACTION =================

  // Future<void> deleteTransaction(String transactionId) async {
  //   final transaction = _transactionBox.get(transactionId);

  //   if (transaction != null) {
  //     // Remove from budget if linked
  //     if (transaction.budgetId != null) {
  //       await _updateBudgetSpent(
  //         transaction.budgetId!,
  //         -transaction.totalAmount, // Subtract
  //       );
  //     }

  //     // Delete linked debt
  //     final debts = _debtBox.values
  //         .where((d) => d.transactionId == transactionId)
  //         .toList();

  //     for (final debt in debts) {
  //       // Delete all payments for this debt
  //       final payments = _debtPaymentBox.values
  //           .where((p) => p.debtId == debt.id)
  //           .toList();
  //       for (final payment in payments) {
  //         await payment.delete();
  //       }
  //       await debt.delete();
  //     }

  //     await transaction.delete();
  //   }
  // }

  Future<void> softDeleteTransaction(String transactionId) async {
    final transaction = _transactionBox.get(transactionId);
    if (transaction != null) {
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
        isDeleted: true, // Mark as deleted
        budgetId: transaction.budgetId,
      );
      await updated.save();
    }
  }

  // ================= FETCH TRANSACTIONS =================

  List<TransactionModel> getAllTransactions({bool includeDeleted = false}) {
    final transactions = _transactionBox.values.toList();
    return (includeDeleted
            ? transactions
            : transactions.where((t) => !t.isDeleted).toList())
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> getRecentTransactions(int limit) {
    final list = getAllTransactions();
    return list.take(limit).toList();
  }

  List<TransactionModel> getTransactionsByType(TransactionType type) {
    return getAllTransactions().where((t) => t.type == type).toList();
  }

  List<TransactionModel> getTransactionsByDate(DateTime date) {
    return getAllTransactions()
        .where(
          (t) =>
              t.date.year == date.year &&
              t.date.month == date.month &&
              t.date.day == date.day,
        )
        .toList();
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return getAllTransactions()
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  List<TransactionModel> getTransactionsByMonth(int year, int month) {
    return getAllTransactions()
        .where((t) => t.date.year == year && t.date.month == month)
        .toList();
  }

  List<TransactionModel> getTransactionsByYear(int year) {
    return getAllTransactions().where((t) => t.date.year == year).toList();
  }

  List<TransactionModel> getTransactionsByCategory(String category) {
    return getAllTransactions()
        .where((t) => t.items.any((item) => item.category == category))
        .toList();
  }

  List<TransactionModel> getTransactionsByPaymentMethod(PaymentMethod method) {
    return getAllTransactions()
        .where((t) => t.paymentMethod == method)
        .toList();
  }

  List<TransactionModel> getTransactionsByBudget(String budgetId) {
    return getAllTransactions().where((t) => t.budgetId == budgetId).toList();
  }

  List<TransactionModel> searchTransactions(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllTransactions()
        .where(
          (t) => t.items.any(
            (item) =>
                item.category.toLowerCase().contains(lowerQuery) ||
                (item.note?.toLowerCase().contains(lowerQuery) ?? false),
          ),
        )
        .toList();
  }

  // ================= STATISTICS =================

  double getTotalIncome({DateTime? start, DateTime? end}) {
    final transactions = start != null && end != null
        ? getTransactionsByDateRange(start, end)
        : getAllTransactions();

    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  double getTotalExpense({DateTime? start, DateTime? end}) {
    final transactions = start != null && end != null
        ? getTransactionsByDateRange(start, end)
        : getAllTransactions();

    return transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  double getBalance({DateTime? start, DateTime? end}) {
    return getTotalIncome(start: start, end: end) -
        getTotalExpense(start: start, end: end);
  }

  double getMonthlyIncome(int year, int month) {
    return getTransactionsByMonth(year, month)
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  double getMonthlyExpense(int year, int month) {
    return getTransactionsByMonth(year, month)
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  Map<String, double> getCategoryWiseExpense({DateTime? start, DateTime? end}) {
    final transactions = start != null && end != null
        ? getTransactionsByDateRange(start, end)
        : getAllTransactions();

    final Map<String, double> categoryTotals = {};

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        for (final item in transaction.items) {
          categoryTotals[item.category] =
              (categoryTotals[item.category] ?? 0) + item.amount;
        }
      }
    }

    return categoryTotals;
  }

  Map<PaymentMethod, double> getPaymentMethodWiseExpense() {
    final Map<PaymentMethod, double> methodTotals = {};

    for (final transaction in getAllTransactions()) {
      if (transaction.type == TransactionType.expense) {
        methodTotals[transaction.paymentMethod] =
            (methodTotals[transaction.paymentMethod] ?? 0) +
            transaction.totalAmount;
      }
    }

    return methodTotals;
  }

  // ================= DEBT MANAGEMENT =================

  DebtModel? getDebtByTransactionId(String transactionId) {
    try {
      return _debtBox.values.firstWhere(
        (d) => d.transactionId == transactionId,
      );
    } catch (_) {
      return null;
    }
  }

  DebtModel? getDebtById(String debtId) {
    return _debtBox.get(debtId);
  }

  List<DebtModel> getAllDebts() {
    return _debtBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<DebtModel> getPendingDebts() {
    return _debtBox.values.where((d) => !d.isReturned).toList();
  }

  List<DebtModel> getBorrowedDebts({bool onlyPending = false}) {
    final debts = _debtBox.values
        .where((d) => d.debtType == DebtType.borrowed)
        .toList();
    return onlyPending ? debts.where((d) => !d.isReturned).toList() : debts;
  }

  List<DebtModel> getLentDebts({bool onlyPending = false}) {
    final debts = _debtBox.values
        .where((d) => d.debtType == DebtType.lent)
        .toList();
    return onlyPending ? debts.where((d) => !d.isReturned).toList() : debts;
  }

  List<DebtModel> getOverdueDebts() {
    final now = DateTime.now();
    return _debtBox.values
        .where((d) => !d.isReturned && d.expectedReturnDate.isBefore(now))
        .toList();
  }

  double getTotalBorrowedAmount({bool onlyPending = false}) {
    return getBorrowedDebts(onlyPending: onlyPending).fold(
      0.0,
      (sum, d) => sum + (onlyPending ? d.remainingAmount : d.totalAmount),
    );
  }

  double getTotalLentAmount({bool onlyPending = false}) {
    return getLentDebts(onlyPending: onlyPending).fold(
      0.0,
      (sum, d) => sum + (onlyPending ? d.remainingAmount : d.totalAmount),
    );
  }

  // ================= DEBT PAYMENT MANAGEMENT =================

  // Future<void> addDebtPayment({
  //   required DebtPaymentModel payment,
  //   required String debtId,
  // }) async {
  //   // Save payment
  //   await _debtPaymentBox.put(payment.id, payment);

  //   // Update debt
  //   final debt = _debtBox.get(debtId);
  //   if (debt != null) {
  //     debt.paidAmount += payment.amount;
  //     debt.paymentIds = [...debt.paymentIds, payment.id];
  //     debt.updatedAt = DateTime.now();

  //     // Check if fully paid
  //     if (debt.paidAmount >= debt.totalAmount) {
  //       debt.isReturned = true;
  //     }

  //     await debt.save();
  //   }
  // }

  // Future<void> deleteDebtPayment(String paymentId) async {
  //   final payment = _debtPaymentBox.get(paymentId);
  //   if (payment != null) {
  //     // Update debt
  //     final debt = _debtBox.get(payment.debtId);
  //     if (debt != null) {
  //       debt.paidAmount -= payment.amount;
  //       debt.paymentIds = debt.paymentIds
  //           .where((id) => id != paymentId)
  //           .toList();
  //       debt.isReturned = false; // Unmark as returned
  //       debt.updatedAt = DateTime.now();
  //       await debt.save();
  //     }

  //     await payment.delete();
  //   }
  // }

  List<DebtPaymentModel> getPaymentsByDebt(String debtId) {
    return _debtPaymentBox.values.where((p) => p.debtId == debtId).toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  Future<void> markDebtAsReturned(String debtId) async {
    final debt = _debtBox.get(debtId);
    if (debt != null) {
      debt.isReturned = true;
      debt.updatedAt = DateTime.now();
      await debt.save();
    }
  }

  // ================= BUDGET MANAGEMENT =================

  // Future<void> _updateBudgetSpent(String budgetId, double amount) async {
  //   final budget = _budgetBox.get(budgetId);
  //   if (budget != null) {
  //     budget.spentAmount = (budget.spentAmount + amount).clamp(
  //       0.0,
  //       double.infinity,
  //     );
  //     budget.updatedAt = DateTime.now();
  //     await budget.save();
  //   }
  // }

  // Future<void> linkTransactionToBudget(
  //   String transactionId,
  //   String budgetId,
  // ) async {
  //   final transaction = _transactionBox.get(transactionId);
  //   final budget = _budgetBox.get(budgetId);

  //   if (transaction != null && budget != null) {
  //     // Remove from old budget if exists
  //     if (transaction.budgetId != null && transaction.budgetId != budgetId) {
  //       await _updateBudgetSpent(
  //         transaction.budgetId!,
  //         -transaction.totalAmount,
  //       );
  //     }

  //     // Update transaction
  //     final updated = TransactionModel(
  //       id: transaction.id,
  //       type: transaction.type,
  //       items: transaction.items,
  //       totalAmount: transaction.totalAmount,
  //       paymentMethod: transaction.paymentMethod,
  //       date: transaction.date,
  //       isDebt: transaction.isDebt,
  //       debtId: transaction.debtId,
  //       tags: transaction.tags,
  //       attachmentPath: transaction.attachmentPath,
  //       isRecurring: transaction.isRecurring,
  //       createdAt: transaction.createdAt,
  //       updatedAt: DateTime.now(),
  //       isDeleted: transaction.isDeleted,
  //       budgetId: budgetId,
  //     );
  //     await updated.save();

  //     // Update budget
  //     await _updateBudgetSpent(budgetId, transaction.totalAmount);

  //     // Add to budget's transaction list
  //     budget.transactionIds = [...budget.transactionIds, transactionId];
  //     await budget.save();
  //   }
  // }

  // Future<void> unlinkTransactionFromBudget(String transactionId) async {
  //   final transaction = _transactionBox.get(transactionId);
  //   if (transaction != null && transaction.budgetId != null) {
  //     await _updateBudgetSpent(transaction.budgetId!, -transaction.totalAmount);

  //     final updated = TransactionModel(
  //       id: transaction.id,
  //       type: transaction.type,
  //       items: transaction.items,
  //       totalAmount: transaction.totalAmount,
  //       paymentMethod: transaction.paymentMethod,
  //       date: transaction.date,
  //       isDebt: transaction.isDebt,
  //       debtId: transaction.debtId,
  //       tags: transaction.tags,
  //       attachmentPath: transaction.attachmentPath,
  //       isRecurring: transaction.isRecurring,
  //       createdAt: transaction.createdAt,
  //       updatedAt: DateTime.now(),
  //       isDeleted: transaction.isDeleted,
  //       budgetId: null,
  //     );
  //     await updated.save();
  //   }
  // }

  // ================= RECURRING TRANSACTIONS =================

  // Future<void> generateDueRecurringTransactions() async {
  //   final now = DateTime.now();
  //   final dueRecurring = _recurringBox.values
  //       .where((r) => r.isActive && r.isDue)
  //       .toList();

  //   for (final recurring in dueRecurring) {
  //     // Create transaction
  //     final transaction = TransactionModel(
  //       id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
  //       type: recurring.type,
  //       items: [
  //         TransactionItemModel(
  //           category: recurring.categoryKey,
  //           amount: recurring.amount,
  //           note: recurring.note,
  //         ),
  //       ],
  //       totalAmount: recurring.amount,
  //       paymentMethod: recurring.paymentMethod,
  //       date: now,
  //       isRecurring: true,
  //     );

  //     await addTransaction(transaction: transaction);

  //     // Update recurring transaction
  //     recurring.generatedTransactionIds = [
  //       ...recurring.generatedTransactionIds,
  //       transaction.id,
  //     ];
  //     recurring.nextOccurrence = _calculateNextOccurrence(recurring);
  //     await recurring.save();
  //   }
  // }

  DateTime _calculateNextOccurrence(RecurringTransactionModel recurring) {
    final current = recurring.nextOccurrence;
    switch (recurring.frequency) {
      case RecurrenceFrequency.daily:
        return current.add(Duration(days: 1));
      case RecurrenceFrequency.weekly:
        return current.add(Duration(days: 7));
      case RecurrenceFrequency.biweekly:
        return current.add(Duration(days: 14));
      case RecurrenceFrequency.monthly:
        return DateTime(current.year, current.month + 1, recurring.dayOfMonth);
      case RecurrenceFrequency.quarterly:
        return DateTime(current.year, current.month + 3, recurring.dayOfMonth);
      case RecurrenceFrequency.yearly:
        return DateTime(current.year + 1, current.month, recurring.dayOfMonth);
    }
  }

  // ================= EXPORT/BACKUP =================

  Map<String, dynamic> exportAllData() {
    return {
      'transactions': _transactionBox.values
          .map(
            (t) => {
              'id': t.id,
              'type': t.type.toString(),
              'totalAmount': t.totalAmount,
              'date': t.date.toIso8601String(),
              // Add all other fields
            },
          )
          .toList(),
      'debts': _debtBox.values
          .map(
            (d) => {
              'id': d.id,
              'personName': d.personName,
              'totalAmount': d.totalAmount,
              // Add all other fields
            },
          )
          .toList(),
      // Add budgets, payments, etc.
    };
  }
}
