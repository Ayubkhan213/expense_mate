import 'package:spendio/core/data/models/analytics_data_models.dart';

abstract class AnalyticsRepository {
  /// Get comprehensive analytics data for the specified date range
  Future<AnalyticsData> getAnalyticsData({
    required DateTime startDate,
    required DateTime endDate,
    String? categoryFilter,
  });

  /// Get financial summary only
  Future<FinancialSummary> getFinancialSummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get category breakdown for expenses
  Future<List<CategoryBreakdown>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get monthly trends
  Future<List<MonthlyTrend>> getMonthlyTrends({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get daily spending pattern
  Future<List<DailySpending>> getDailySpending({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get budget analysis
  Future<BudgetAnalysis> getBudgetAnalysis({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get debt analysis
  Future<DebtAnalysis> getDebtAnalysis();

  /// Get payment method breakdown
  Future<PaymentMethodBreakdown> getPaymentMethodBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get top transactions (highest expenses)
  Future<List<TopTransaction>> getTopTransactions({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  });
}
