import 'package:expense_mate/features/analytics/presentation/components/budget_overview_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/category_chart_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/debt_overview_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/financial_summary_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/monthly_trend_chart.dart';
import 'package:expense_mate/features/analytics/presentation/components/payment_method_chart.dart';
import 'package:expense_mate/features/analytics/presentation/components/period_selector.dart';
import 'package:expense_mate/features/analytics/presentation/components/top_transactions_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';

class AnalyticsFace extends StatelessWidget {
  const AnalyticsFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics'), elevation: 0),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsInitial) {
            _loadInitialData(context);
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _loadInitialData(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AnalyticsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AnalyticsBloc>().add(const RefreshAnalytics());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period Selector
                    PeriodSelector(
                      currentPeriod: state.currentPeriod,
                      onPeriodChanged: (period) {
                        context.read<AnalyticsBloc>().add(
                          FilterAnalyticsByPeriod(period),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Financial Summary
                    FinancialSummaryCard(summary: state.data.summary),

                    const SizedBox(height: 16),

                    // Category Breakdown Chart
                    CategoryChartCard(
                      categoryBreakdown: state.data.categoryBreakdown,
                    ),

                    const SizedBox(height: 16),

                    // Monthly Trends
                    MonthlyTrendChart(monthlyTrends: state.data.monthlyTrends),

                    const SizedBox(height: 16),

                    // Budget Overview
                    BudgetOverviewCard(
                      budgetAnalysis: state.data.budgetAnalysis,
                    ),

                    const SizedBox(height: 16),

                    // Debt Overview
                    DebtOverviewCard(debtAnalysis: state.data.debtAnalysis),

                    const SizedBox(height: 16),

                    // Payment Method Distribution
                    PaymentMethodChart(
                      paymentMethodBreakdown: state.data.paymentMethodBreakdown,
                    ),

                    const SizedBox(height: 16),

                    // Top Transactions
                    TopTransactionsCard(
                      topTransactions: state.data.topTransactions,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _loadInitialData(BuildContext context) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    context.read<AnalyticsBloc>().add(
      LoadAnalyticsData(startDate: startOfMonth, endDate: endOfMonth),
    );
  }
}
