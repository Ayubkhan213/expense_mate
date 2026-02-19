import 'package:expense_mate/core/data/models/analytics_data_models.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/features/analytics/domain/repository/analytics_repository.dart';
import 'package:hive/hive.dart';

import '../../../../core/data/models/transaction_model.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final Box<TransactionModel> transactionBox;
  final Box<BudgetModel> budgetBox;
  final Box<DebtModel> debtBox;
  final Box<CategoryHiveModel> categoryBox;

  AnalyticsRepositoryImpl({
    required this.transactionBox,
    required this.budgetBox,
    required this.debtBox,
    required this.categoryBox,
  });

  @override
  Future<AnalyticsData> getAnalyticsData({
    required DateTime startDate,
    required DateTime endDate,
    String? categoryFilter,
  }) async {
    final summary = await getFinancialSummary(
      startDate: startDate,
      endDate: endDate,
    );

    final categoryBreakdown = await getCategoryBreakdown(
      startDate: startDate,
      endDate: endDate,
    );

    final monthlyTrends = await getMonthlyTrends(
      startDate: startDate,
      endDate: endDate,
    );

    final dailySpending = await getDailySpending(
      startDate: startDate,
      endDate: endDate,
    );

    final budgetAnalysis = await getBudgetAnalysis(
      startDate: startDate,
      endDate: endDate,
    );

    final debtAnalysis = await getDebtAnalysis();

    final paymentMethodBreakdown = await getPaymentMethodBreakdown(
      startDate: startDate,
      endDate: endDate,
    );

    final topTransactions = await getTopTransactions(
      startDate: startDate,
      endDate: endDate,
    );

    return AnalyticsData(
      summary: summary,
      categoryBreakdown: categoryBreakdown,
      monthlyTrends: monthlyTrends,
      dailySpending: dailySpending,
      budgetAnalysis: budgetAnalysis,
      debtAnalysis: debtAnalysis,
      paymentMethodBreakdown: paymentMethodBreakdown,
      topTransactions: topTransactions,
    );
  }

  @override
  Future<FinancialSummary> getFinancialSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final transactions = _getTransactionsInRange(startDate, endDate);

    double totalIncome = 0;
    double totalExpense = 0;
    int transactionCount = transactions.length;

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.totalAmount;
      } else {
        totalExpense += transaction.totalAmount;
      }
    }

    final netBalance = totalIncome - totalExpense;
    final daysDifference = endDate.difference(startDate).inDays + 1;
    final averageDailyExpense = daysDifference > 0
        ? totalExpense / daysDifference
        : 0;

    final averageTransactionAmount = transactionCount > 0
        ? (totalIncome + totalExpense) / transactionCount
        : 0;

    final savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpense) / totalIncome * 100)
        : 0;

    return FinancialSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: netBalance,
      averageDailyExpense: double.parse(averageDailyExpense.toString()),
      averageTransactionAmount: double.parse(
        averageTransactionAmount.toString(),
      ),
      totalTransactions: transactionCount,
      savingsRate: double.parse(savingsRate.toString()),
    );
  }

  @override
  Future<List<CategoryBreakdown>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final transactions = _getTransactionsInRange(
      startDate,
      endDate,
    ).where((t) => t.type == TransactionType.expense).toList();

    final Map<String, CategoryData> categoryMap = {};
    double totalExpense = 0;

    for (var transaction in transactions) {
      for (var item in transaction.items) {
        totalExpense += item.amount;

        // Get category info from categoryBox
        final category = _getCategoryByKey(item.category);
        final categoryKey = item.category;
        final colorValue = category?.colorValue ?? 0xFF9E9E9E;
        final iconCode = category?.iconCode ?? 0xe86f; // default icon

        if (categoryMap.containsKey(categoryKey)) {
          categoryMap[categoryKey]!.amount += item.amount;
          categoryMap[categoryKey]!.count += 1;
        } else {
          categoryMap[categoryKey] = CategoryData(
            amount: item.amount,
            count: 1,
            colorValue: colorValue,
            iconCode: iconCode,
          );
        }
      }
    }

    return categoryMap.entries.map((entry) {
      final percentage = totalExpense > 0
          ? (entry.value.amount / totalExpense * 100)
          : 0.0;

      return CategoryBreakdown(
        categoryKey: entry.key,
        amount: entry.value.amount,
        percentage: percentage,
        transactionCount: entry.value.count,
        colorValue: entry.value.colorValue,
        iconCode: entry.value.iconCode,
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));
  }

  @override
  Future<List<MonthlyTrend>> getMonthlyTrends({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final transactions = _getTransactionsInRange(startDate, endDate);
    final Map<String, MonthlyData> monthlyMap = {};

    for (var transaction in transactions) {
      final monthKey =
          '${_getMonthName(transaction.date.month)} ${transaction.date.year}';

      if (!monthlyMap.containsKey(monthKey)) {
        monthlyMap[monthKey] = MonthlyData(
          month: monthKey,
          income: 0,
          expense: 0,
        );
      }

      if (transaction.type == TransactionType.income) {
        monthlyMap[monthKey]!.income += transaction.totalAmount;
      } else {
        monthlyMap[monthKey]!.expense += transaction.totalAmount;
      }
    }

    return monthlyMap.values.map((data) {
      return MonthlyTrend(
        month: data.month,
        income: data.income,
        expense: data.expense,
        net: data.income - data.expense,
      );
    }).toList();
  }

  @override
  Future<List<DailySpending>> getDailySpending({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final transactions = _getTransactionsInRange(
      startDate,
      endDate,
    ).where((t) => t.type == TransactionType.expense).toList();

    final Map<DateTime, double> dailyMap = {};

    for (var transaction in transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      dailyMap[date] = (dailyMap[date] ?? 0) + transaction.totalAmount;
    }

    return dailyMap.entries
        .map((entry) => DailySpending(date: entry.key, amount: entry.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<BudgetAnalysis> getBudgetAnalysis({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final budgets = budgetBox.values
        .where(
          (b) =>
              !b.isArchived &&
              b.startDate.isBefore(endDate) &&
              b.endDate.isAfter(startDate),
        )
        .toList();

    int activeBudgets = budgets.where((b) => b.isActive).length;
    int overBudgetCount = budgets.where((b) => b.isOverBudget).length;

    double totalBudgetAmount = 0;
    double totalSpentAmount = 0;

    final List<BudgetProgress> progresses = [];

    for (var budget in budgets) {
      totalBudgetAmount += budget.totalAmount;
      totalSpentAmount += budget.spentAmount;

      progresses.add(
        BudgetProgress(
          budgetName: budget.name,
          budgetAmount: budget.totalAmount,
          spentAmount: budget.spentAmount,
          percentage: budget.spentPercentage,
          isOverBudget: budget.isOverBudget,
          colorCode: budget.colorCode,
        ),
      );
    }

    final overallUtilization = totalBudgetAmount > 0
        ? (totalSpentAmount / totalBudgetAmount * 100)
        : 0.0;

    return BudgetAnalysis(
      totalBudgets: budgets.length,
      activeBudgets: activeBudgets,
      overBudgetCount: overBudgetCount,
      totalBudgetAmount: totalBudgetAmount,
      totalSpentAmount: totalSpentAmount,
      overallBudgetUtilization: overallUtilization,
      budgetProgresses: progresses,
    );
  }

  @override
  Future<DebtAnalysis> getDebtAnalysis() async {
    final debts = debtBox.values.toList();

    double totalBorrowed = 0;
    double totalLent = 0;
    double borrowedRemaining = 0;
    double lentRemaining = 0;
    int activeBorrowedCount = 0;
    int activeLentCount = 0;
    int overdueBorrowedCount = 0;
    int overdueLentCount = 0;

    for (var debt in debts) {
      if (debt.debtType == DebtType.borrowed) {
        totalBorrowed += debt.totalAmount;
        if (!debt.isReturned) {
          borrowedRemaining += debt.remainingAmount;
          activeBorrowedCount++;
          if (debt.isOverdue) overdueBorrowedCount++;
        }
      } else {
        totalLent += debt.totalAmount;
        if (!debt.isReturned) {
          lentRemaining += debt.remainingAmount;
          activeLentCount++;
          if (debt.isOverdue) overdueLentCount++;
        }
      }
    }

    return DebtAnalysis(
      totalBorrowed: totalBorrowed,
      totalLent: totalLent,
      borrowedRemaining: borrowedRemaining,
      lentRemaining: lentRemaining,
      activeBorrowedCount: activeBorrowedCount,
      activeLentCount: activeLentCount,
      overdueBorrowedCount: overdueBorrowedCount,
      overdueLentCount: overdueLentCount,
    );
  }

  @override
  Future<PaymentMethodBreakdown> getPaymentMethodBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final transactions = _getTransactionsInRange(startDate, endDate);

    final Map<String, double> methodAmounts = {};
    final Map<String, int> methodCounts = {};

    for (var transaction in transactions) {
      final method = transaction.paymentMethod.name;
      methodAmounts[method] =
          (methodAmounts[method] ?? 0) + transaction.totalAmount;
      methodCounts[method] = (methodCounts[method] ?? 0) + 1;
    }

    return PaymentMethodBreakdown(
      methodAmounts: methodAmounts,
      methodCounts: methodCounts,
    );
  }

  @override
  Future<List<TopTransaction>> getTopTransactions({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    final transactions =
        _getTransactionsInRange(
            startDate,
            endDate,
          ).where((t) => t.type == TransactionType.expense).toList()
          ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    final topTrans = transactions.take(limit).toList();

    return topTrans.map((t) {
      final categoryKey = t.items.isNotEmpty
          ? t.items.first.category
          : 'unknown';

      final note = t.items.isNotEmpty && t.items.first.note != null
          ? t.items.first.note
          : null;

      return TopTransaction(
        id: t.id,
        categoryKey: categoryKey,
        amount: t.totalAmount,
        date: t.date,
        note: note,
      );
    }).toList();
  }

  // Helper methods
  List<TransactionModel> _getTransactionsInRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return transactionBox.values
        .where(
          (t) =>
              !t.isDeleted &&
              t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
  }

  CategoryHiveModel? _getCategoryByKey(String key) {
    try {
      return categoryBox.values.firstWhere((cat) => cat.key == key);
    } catch (e) {
      return null;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

// Helper classes for data aggregation
class CategoryData {
  double amount;
  int count;
  final int colorValue;
  final int iconCode;

  CategoryData({
    required this.amount,
    required this.count,
    required this.colorValue,
    required this.iconCode,
  });
}

class MonthlyData {
  final String month;
  double income;
  double expense;

  MonthlyData({
    required this.month,
    required this.income,
    required this.expense,
  });
}
