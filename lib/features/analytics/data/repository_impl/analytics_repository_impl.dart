import 'package:spendio/core/data/models/analytics_data_models.dart';
import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_item_sql_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/services/app_prefs.dart';
import 'package:spendio/features/analytics/domain/repository/analytics_repository.dart';

import '../../../../core/domain/entity/transcation_item_entity.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final SqliteHelper _db = SqliteHelper.instance;

  // ── Current logged-in user ─────────────────────────────────────────────────
  String get _userId => AppPrefs.instance.userId ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // TOP-LEVEL AGGREGATOR
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<AnalyticsData> getAnalyticsData({
    required DateTime startDate,
    required DateTime endDate,
    String? categoryFilter,
  }) async {
    final transactions = await _getTransactionsInRange(startDate, endDate);
    final categories = await _getAllCategories();
    final debts = await _getAllDebts();
    final budgets = await _getBudgetsInRange(startDate, endDate);

    final summary = _buildSummary(transactions, startDate, endDate);
    final categoryBreakdown = _buildCategoryBreakdown(transactions, categories);
    final monthlyTrends = _buildMonthlyTrends(transactions);
    final dailySpending = _buildDailySpending(transactions);
    final budgetAnalysis = _buildBudgetAnalysis(budgets);
    final debtAnalysis = _buildDebtAnalysis(debts);
    final paymentMethodBreakdown = _buildPaymentMethodBreakdown(transactions);
    final topTransactions = _buildTopTransactions(transactions);

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

  // ═══════════════════════════════════════════════════════════════════════════
  // DB FETCHERS — all scoped to current user_id
  // ═══════════════════════════════════════════════════════════════════════════

  Future<List<TransactionModel>> _getTransactionsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final rows = await _db.queryWhere(
      DbConstants.tableTransactions,
      where:
          '${DbConstants.colIsDeleted} = 0 '
          'AND ${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colTxnDate} >= ? '
          'AND ${DbConstants.colTxnDate} <= ?',
      whereArgs: [
        _userId,
        startDate.subtract(const Duration(days: 1)).toIso8601String(),
        endDate.add(const Duration(days: 1)).toIso8601String(),
      ],
    );

    final List<TransactionModel> result = [];
    for (final row in rows) {
      final itemRows = await _db.queryWhere(
        DbConstants.tableTransactionItems,
        where: '${DbConstants.colTxnItemTransactionId} = ?',
        whereArgs: [row['id'] as String],
      );
      final items = itemRows
          .map<TransactionItemEntity>((r) => TransactionItemModel.fromMap(r))
          .toList();
      result.add(TransactionModel.fromMap(row, items));
    }
    return result;
  }

  // Categories are global (shared) — no user_id filter needed
  Future<List<CategoryModel>> _getAllCategories() async {
    final rows = await _db.queryAll(DbConstants.tableCategories);
    return rows.map((r) => CategoryModel.fromMap(r)).toList();
  }

  Future<List<DebtModel>> _getAllDebts() async {
    final rows = await _db.queryWhere(
      DbConstants.tableDebts,
      where: '${DbConstants.colUserId} = ?',
      whereArgs: [_userId],
    );
    return rows.map((r) => DebtModel.fromMap(r)).toList();
  }

  Future<List<BudgetModel>> _getBudgetsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final rows = await _db.queryWhere(
      DbConstants.tableBudgets,
      where:
          '${DbConstants.colUserId} = ? '
          'AND ${DbConstants.colBudgetIsArchived} = 0 '
          'AND ${DbConstants.colBudgetStartDate} <= ? '
          'AND ${DbConstants.colBudgetEndDate} >= ?',
      whereArgs: [
        _userId,
        endDate.toIso8601String(),
        startDate.toIso8601String(),
      ],
    );
    return rows
        .map((r) => BudgetModel.fromMap(r, transactionIds: const []))
        .toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PURE BUILDERS — unchanged, operate on pre-fetched lists
  // ═══════════════════════════════════════════════════════════════════════════

  FinancialSummary _buildSummary(
    List<TransactionModel> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    double totalIncome = 0;
    double totalExpense = 0;

    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        totalIncome += t.totalAmount;
      } else {
        totalExpense += t.totalAmount;
      }
    }

    final days = endDate.difference(startDate).inDays + 1;
    final count = transactions.length;

    return FinancialSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: totalIncome - totalExpense,
      averageDailyExpense: days > 0 ? totalExpense / days : 0,
      averageTransactionAmount: count > 0
          ? (totalIncome + totalExpense) / count
          : 0,
      totalTransactions: count,
      savingsRate: totalIncome > 0
          ? ((totalIncome - totalExpense) / totalIncome * 100)
          : 0,
    );
  }

  List<CategoryBreakdown> _buildCategoryBreakdown(
    List<TransactionModel> transactions,
    List<CategoryModel> categories,
  ) {
    final expenses = transactions.where(
      (t) => t.type == TransactionType.expense,
    );
    final Map<String, _CategoryData> map = {};
    double total = 0;

    for (final t in expenses) {
      for (final item in t.items) {
        total += item.amount;
        final cat = categories.firstWhere(
          (c) => c.key == item.category,
          orElse: () => CategoryModel(
            key: item.category,
            iconCode: 0xe86f,
            colorValue: 0xFF9E9E9E,
            isIncome: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        if (map.containsKey(item.category)) {
          map[item.category]!.amount += item.amount;
          map[item.category]!.count++;
        } else {
          map[item.category] = _CategoryData(
            amount: item.amount,
            count: 1,
            colorValue: cat.colorValue,
            iconCode: cat.iconCode,
          );
        }
      }
    }

    return map.entries.map((e) {
      return CategoryBreakdown(
        categoryKey: e.key,
        amount: e.value.amount,
        percentage: total > 0 ? e.value.amount / total * 100 : 0,
        transactionCount: e.value.count,
        colorValue: e.value.colorValue,
        iconCode: e.value.iconCode,
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));
  }

  List<MonthlyTrend> _buildMonthlyTrends(List<TransactionModel> transactions) {
    final Map<String, _MonthlyData> map = {};

    for (final t in transactions) {
      final key = '${_monthName(t.date.month)} ${t.date.year}';
      map.putIfAbsent(
        key,
        () => _MonthlyData(month: key, income: 0, expense: 0),
      );
      if (t.type == TransactionType.income) {
        map[key]!.income += t.totalAmount;
      } else {
        map[key]!.expense += t.totalAmount;
      }
    }

    return map.values
        .map(
          (d) => MonthlyTrend(
            month: d.month,
            income: d.income,
            expense: d.expense,
            net: d.income - d.expense,
          ),
        )
        .toList();
  }

  List<DailySpending> _buildDailySpending(List<TransactionModel> transactions) {
    final expenses = transactions.where(
      (t) => t.type == TransactionType.expense,
    );
    final Map<DateTime, double> map = {};

    for (final t in expenses) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      map[day] = (map[day] ?? 0) + t.totalAmount;
    }

    return map.entries
        .map((e) => DailySpending(date: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  BudgetAnalysis _buildBudgetAnalysis(List<BudgetModel> budgets) {
    double totalBudget = 0;
    double totalSpent = 0;
    final List<BudgetProgress> progresses = [];

    for (final b in budgets) {
      totalBudget += b.totalAmount;
      totalSpent += b.spentAmount;
      progresses.add(
        BudgetProgress(
          budgetName: b.name,
          budgetAmount: b.totalAmount,
          spentAmount: b.spentAmount,
          percentage: b.spentPercentage,
          isOverBudget: b.isOverBudget,
          colorCode: b.colorCode,
        ),
      );
    }

    return BudgetAnalysis(
      totalBudgets: budgets.length,
      activeBudgets: budgets.where((b) => b.isActive).length,
      overBudgetCount: budgets.where((b) => b.isOverBudget).length,
      totalBudgetAmount: totalBudget,
      totalSpentAmount: totalSpent,
      overallBudgetUtilization: totalBudget > 0
          ? totalSpent / totalBudget * 100
          : 0,
      budgetProgresses: progresses,
    );
  }

  DebtAnalysis _buildDebtAnalysis(List<DebtModel> debts) {
    double totalBorrowed = 0,
        totalLent = 0,
        borrowedRemaining = 0,
        lentRemaining = 0;
    int activeBorrowed = 0,
        activeLent = 0,
        overdueBorrowed = 0,
        overdueLent = 0;

    for (final d in debts) {
      if (d.debtType == DebtType.borrowed) {
        totalBorrowed += d.totalAmount;
        if (!d.isReturned) {
          borrowedRemaining += d.remainingAmount;
          activeBorrowed++;
          if (d.isOverdue) overdueBorrowed++;
        }
      } else {
        totalLent += d.totalAmount;
        if (!d.isReturned) {
          lentRemaining += d.remainingAmount;
          activeLent++;
          if (d.isOverdue) overdueLent++;
        }
      }
    }

    return DebtAnalysis(
      totalBorrowed: totalBorrowed,
      totalLent: totalLent,
      borrowedRemaining: borrowedRemaining,
      lentRemaining: lentRemaining,
      activeBorrowedCount: activeBorrowed,
      activeLentCount: activeLent,
      overdueBorrowedCount: overdueBorrowed,
      overdueLentCount: overdueLent,
    );
  }

  PaymentMethodBreakdown _buildPaymentMethodBreakdown(
    List<TransactionModel> transactions,
  ) {
    final Map<String, double> amounts = {};
    final Map<String, int> counts = {};

    for (final t in transactions) {
      final m = t.paymentMethod.name;
      amounts[m] = (amounts[m] ?? 0) + t.totalAmount;
      counts[m] = (counts[m] ?? 0) + 1;
    }

    return PaymentMethodBreakdown(methodAmounts: amounts, methodCounts: counts);
  }

  List<TopTransaction> _buildTopTransactions(
    List<TransactionModel> transactions, {
    int limit = 10,
  }) {
    final expenses =
        transactions.where((t) => t.type == TransactionType.expense).toList()
          ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return expenses.take(limit).map((t) {
      return TopTransaction(
        id: t.id,
        categoryKey: t.items.isNotEmpty ? t.items.first.category : 'unknown',
        amount: t.totalAmount,
        date: t.date,
        note: t.items.isNotEmpty ? t.items.first.note : null,
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC OVERRIDES
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<FinancialSummary> getFinancialSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final txns = await _getTransactionsInRange(startDate, endDate);
    return _buildSummary(txns, startDate, endDate);
  }

  @override
  Future<List<CategoryBreakdown>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final txns = await _getTransactionsInRange(startDate, endDate);
    final cats = await _getAllCategories();
    return _buildCategoryBreakdown(txns, cats);
  }

  @override
  Future<List<MonthlyTrend>> getMonthlyTrends({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final txns = await _getTransactionsInRange(startDate, endDate);
    return _buildMonthlyTrends(txns);
  }

  @override
  Future<List<DailySpending>> getDailySpending({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final txns = await _getTransactionsInRange(startDate, endDate);
    return _buildDailySpending(txns);
  }

  @override
  Future<BudgetAnalysis> getBudgetAnalysis({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final budgets = await _getBudgetsInRange(startDate, endDate);
    return _buildBudgetAnalysis(budgets);
  }

  @override
  Future<DebtAnalysis> getDebtAnalysis() async {
    final debts = await _getAllDebts();
    return _buildDebtAnalysis(debts);
  }

  @override
  Future<PaymentMethodBreakdown> getPaymentMethodBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final txns = await _getTransactionsInRange(startDate, endDate);
    return _buildPaymentMethodBreakdown(txns);
  }

  @override
  Future<List<TopTransaction>> getTopTransactions({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    final txns = await _getTransactionsInRange(startDate, endDate);
    return _buildTopTransactions(txns, limit: limit);
  }

  // ── Utilities ──────────────────────────────────────────────────────────────

  String _monthName(int month) => const [
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
  ][month - 1];
}

// ── Private helper classes ────────────────────────────────────────────────────

class _CategoryData {
  double amount;
  int count;
  final int colorValue;
  final int iconCode;
  _CategoryData({
    required this.amount,
    required this.count,
    required this.colorValue,
    required this.iconCode,
  });
}

class _MonthlyData {
  final String month;
  double income;
  double expense;
  _MonthlyData({
    required this.month,
    required this.income,
    required this.expense,
  });
}
