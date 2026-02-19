import 'package:equatable/equatable.dart';

class AnalyticsData extends Equatable {
  final FinancialSummary summary;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<MonthlyTrend> monthlyTrends;
  final List<DailySpending> dailySpending;
  final BudgetAnalysis budgetAnalysis;
  final DebtAnalysis debtAnalysis;
  final PaymentMethodBreakdown paymentMethodBreakdown;
  final List<TopTransaction> topTransactions;

  const AnalyticsData({
    required this.summary,
    required this.categoryBreakdown,
    required this.monthlyTrends,
    required this.dailySpending,
    required this.budgetAnalysis,
    required this.debtAnalysis,
    required this.paymentMethodBreakdown,
    required this.topTransactions,
  });

  @override
  List<Object?> get props => [
    summary,
    categoryBreakdown,
    monthlyTrends,
    dailySpending,
    budgetAnalysis,
    debtAnalysis,
    paymentMethodBreakdown,
    topTransactions,
  ];
}

class FinancialSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final double averageDailyExpense;
  final double averageTransactionAmount;
  final int totalTransactions;
  final double savingsRate; // (income - expense) / income * 100

  const FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.averageDailyExpense,
    required this.averageTransactionAmount,
    required this.totalTransactions,
    required this.savingsRate,
  });

  @override
  List<Object?> get props => [
    totalIncome,
    totalExpense,
    netBalance,
    averageDailyExpense,
    averageTransactionAmount,
    totalTransactions,
    savingsRate,
  ];
}

class CategoryBreakdown extends Equatable {
  final String categoryKey;
  final double amount;
  final double percentage;
  final int transactionCount;
  final int colorValue;
  final int iconCode;

  const CategoryBreakdown({
    required this.categoryKey,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
    required this.colorValue,
    required this.iconCode,
  });

  @override
  List<Object?> get props => [
    categoryKey,
    amount,
    percentage,
    transactionCount,
    colorValue,
    iconCode,
  ];
}

class MonthlyTrend extends Equatable {
  final String month; // "Jan 2025"
  final double income;
  final double expense;
  final double net;

  const MonthlyTrend({
    required this.month,
    required this.income,
    required this.expense,
    required this.net,
  });

  @override
  List<Object?> get props => [month, income, expense, net];
}

class DailySpending extends Equatable {
  final DateTime date;
  final double amount;

  const DailySpending({required this.date, required this.amount});

  @override
  List<Object?> get props => [date, amount];
}

class BudgetAnalysis extends Equatable {
  final int totalBudgets;
  final int activeBudgets;
  final int overBudgetCount;
  final double totalBudgetAmount;
  final double totalSpentAmount;
  final double overallBudgetUtilization; // percentage
  final List<BudgetProgress> budgetProgresses;

  const BudgetAnalysis({
    required this.totalBudgets,
    required this.activeBudgets,
    required this.overBudgetCount,
    required this.totalBudgetAmount,
    required this.totalSpentAmount,
    required this.overallBudgetUtilization,
    required this.budgetProgresses,
  });

  @override
  List<Object?> get props => [
    totalBudgets,
    activeBudgets,
    overBudgetCount,
    totalBudgetAmount,
    totalSpentAmount,
    overallBudgetUtilization,
    budgetProgresses,
  ];
}

class BudgetProgress extends Equatable {
  final String budgetName;
  final double budgetAmount;
  final double spentAmount;
  final double percentage;
  final bool isOverBudget;
  final int? colorCode;

  const BudgetProgress({
    required this.budgetName,
    required this.budgetAmount,
    required this.spentAmount,
    required this.percentage,
    required this.isOverBudget,
    this.colorCode,
  });

  @override
  List<Object?> get props => [
    budgetName,
    budgetAmount,
    spentAmount,
    percentage,
    isOverBudget,
    colorCode,
  ];
}

class DebtAnalysis extends Equatable {
  final double totalBorrowed;
  final double totalLent;
  final double borrowedRemaining;
  final double lentRemaining;
  final int activeBorrowedCount;
  final int activeLentCount;
  final int overdueBorrowedCount;
  final int overdueLentCount;

  const DebtAnalysis({
    required this.totalBorrowed,
    required this.totalLent,
    required this.borrowedRemaining,
    required this.lentRemaining,
    required this.activeBorrowedCount,
    required this.activeLentCount,
    required this.overdueBorrowedCount,
    required this.overdueLentCount,
  });

  @override
  List<Object?> get props => [
    totalBorrowed,
    totalLent,
    borrowedRemaining,
    lentRemaining,
    activeBorrowedCount,
    activeLentCount,
    overdueBorrowedCount,
    overdueLentCount,
  ];
}

class PaymentMethodBreakdown extends Equatable {
  final Map<String, double> methodAmounts; // "cash": 1500.0
  final Map<String, int> methodCounts; // "cash": 45

  const PaymentMethodBreakdown({
    required this.methodAmounts,
    required this.methodCounts,
  });

  @override
  List<Object?> get props => [methodAmounts, methodCounts];
}

class TopTransaction extends Equatable {
  final String id;
  final String categoryKey;
  final double amount;
  final DateTime date;
  final String? note;

  const TopTransaction({
    required this.id,
    required this.categoryKey,
    required this.amount,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [id, categoryKey, amount, date, note];
}
