import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/features/analytics/presentation/components/budget_overview_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/category_chart_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/debt_overview_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/financial_summary_card.dart';
import 'package:expense_mate/features/analytics/presentation/components/monthly_trend_chart.dart';
import 'package:expense_mate/features/analytics/presentation/components/payment_method_chart.dart';
import 'package:expense_mate/features/analytics/presentation/components/top_transactions_card.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';

class AnalyticsFace extends StatelessWidget {
  const AnalyticsFace({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.colorScheme.background
          : const Color(0xFFF2F4F8),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsInitial) {
            _loadInitialData(context);
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AnalyticsLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 2.5,
              ),
            );
          }
          if (state is AnalyticsError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => _loadInitialData(context),
            );
          }
          if (state is AnalyticsLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<AnalyticsBloc>().add(const RefreshAnalytics()),
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  _AnalyticsSliverAppBar(state: state, isDark: isDark),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PeriodFilterDelegate(
                      currentPeriod: state.currentPeriod,
                      isDark: isDark,
                      onPeriodChanged: (period) => context
                          .read<AnalyticsBloc>()
                          .add(FilterAnalyticsByPeriod(period)),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        FinancialSummaryCard(summary: state.data.summary),
                        const SizedBox(height: 16),
                        CategoryChartCard(
                          categoryBreakdown: state.data.categoryBreakdown,
                        ),
                        const SizedBox(height: 16),
                        MonthlyTrendChart(
                          monthlyTrends: state.data.monthlyTrends,
                        ),
                        const SizedBox(height: 16),
                        BudgetOverviewCard(
                          budgetAnalysis: state.data.budgetAnalysis,
                        ),
                        const SizedBox(height: 16),
                        DebtOverviewCard(debtAnalysis: state.data.debtAnalysis),
                        const SizedBox(height: 16),
                        PaymentMethodChart(
                          paymentMethodBreakdown:
                              state.data.paymentMethodBreakdown,
                        ),
                        const SizedBox(height: 16),
                        TopTransactionsCard(
                          topTransactions: state.data.topTransactions,
                        ),
                        const SizedBox(height: 110),
                      ]),
                    ),
                  ),
                ],
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
    context.read<AnalyticsBloc>().add(
      LoadAnalyticsData(
        startDate: DateTime(now.year, now.month, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Hero SliverAppBar
// ─────────────────────────────────────────
class _AnalyticsSliverAppBar extends StatelessWidget {
  final AnalyticsLoaded state;
  final bool isDark;

  const _AnalyticsSliverAppBar({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;
    const expandedHeight = 240.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: 64,
      pinned: true,
      stretch: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final current = constraints.maxHeight;
          final progress =
              ((expandedHeight - current) / (expandedHeight - collapsedHeight))
                  .clamp(0.0, 1.0);
          final expandedOpacity = (1.0 - progress).clamp(0.0, 1.0);
          final collapsedOpacity = ((progress - 0.20) / 0.30).clamp(0.0, 1.0);

          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (expandedOpacity > 0)
                  Opacity(
                    opacity: expandedOpacity,
                    child: _ExpandedHeader(
                      state: state,
                      primary: primary,
                      topPad: topPad,
                      availableHeight: current,
                    ),
                  ),
                if (collapsedOpacity > 0)
                  Opacity(
                    opacity: collapsedOpacity,
                    child: _CollapsedHeader(
                      state: state,
                      primary: primary,
                      topPad: topPad,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Expanded header ──
class _ExpandedHeader extends StatelessWidget {
  final AnalyticsLoaded state;
  final Color primary;
  final double topPad;
  final double availableHeight;

  const _ExpandedHeader({
    required this.state,
    required this.primary,
    required this.topPad,
    required this.availableHeight,
  });

  @override
  Widget build(BuildContext context) {
    final summary = state.data.summary;
    final isPositive = summary.netBalance >= 0;
    final balanceColor = isPositive
        ? const Color(0xFF10b981)
        : const Color(0xFFef4444);
    final t = AppLocalizations.of(context)!;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withValues(alpha: 0.85)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: availableHeight,
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.analytics,
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${summary.totalTransactions} ${t.transactionsThisPeriod}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ).paddingOnly(left: 10.0),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Summary card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.netBalance,
                                style: AppTextStyles.captionSmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${isPositive ? '+' : '-'}\$${summary.netBalance.abs().toStringAsFixed(0)}',
                                style: AppTextStyles.currencyLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: balanceColor.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive
                                      ? Icons.trending_up_rounded
                                      : Icons.trending_down_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isPositive ? t.surplus : t.deficit,
                                  style: AppTextStyles.overline.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _Pill(
                            label: t.income,
                            value:
                                '\$${summary.totalIncome.toStringAsFixed(0)}',
                            icon: Icons.arrow_downward_rounded,
                          ),
                          const SizedBox(width: 10),
                          _Pill(
                            label: t.expense,
                            value:
                                '\$${summary.totalExpense.toStringAsFixed(0)}',
                            icon: Icons.arrow_upward_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Collapsed header — key metrics visible when scrolled up ──
class _CollapsedHeader extends StatelessWidget {
  final AnalyticsLoaded state;
  final Color primary;
  final double topPad;

  const _CollapsedHeader({
    required this.state,
    required this.primary,
    required this.topPad,
  });

  @override
  Widget build(BuildContext context) {
    final summary = state.data.summary;
    final isPositive = summary.netBalance >= 0;
    final balanceColor = isPositive
        ? const Color(0xFF10b981)
        : const Color(0xFFef4444);
    final t = AppLocalizations.of(context)!;

    return Container(
      color: primary,
      padding: EdgeInsets.only(top: topPad),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Screen title
            Text(
              t.analytics,
              style: AppTextStyles.h5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(width: 10),

            // Net balance — most important metric
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: balanceColor.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : '-'}\$${summary.netBalance.abs().toStringAsFixed(0)}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Income mini-pill
            _MiniPill(
              icon: Icons.arrow_downward_rounded,
              value: '\$${summary.totalIncome.toStringAsFixed(0)}',
              iconColor: const Color(0xFF10b981),
            ),
            const SizedBox(width: 6),

            // Expense mini-pill
            _MiniPill(
              icon: Icons.arrow_upward_rounded,
              value: '\$${summary.totalExpense.toStringAsFixed(0)}',
              iconColor: const Color(0xFFef4444),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color iconColor;

  const _MiniPill({
    required this.icon,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: iconColor),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTextStyles.overline.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Pinned period filter bar — fixed height 48px
// ─────────────────────────────────────────
class _PeriodFilterDelegate extends SliverPersistentHeaderDelegate {
  final AnalyticsPeriod currentPeriod;
  final bool isDark;
  final ValueChanged<AnalyticsPeriod> onPeriodChanged;

  _PeriodFilterDelegate({
    required this.currentPeriod,
    required this.isDark,
    required this.onPeriodChanged,
  });

  static const double _height = 48.0;

  // ✅ removed static _periods — labels now come from translations
  List<(AnalyticsPeriod, String)> _getPeriods(AppLocalizations t) => [
    (AnalyticsPeriod.week, t.week),
    (AnalyticsPeriod.month, t.month),
    (AnalyticsPeriod.threeMonths, t.threeMonths),
    (AnalyticsPeriod.sixMonths, t.sixMonths),
    (AnalyticsPeriod.year, t.year),
    (AnalyticsPeriod.all, t.allTime),
  ];

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final t = AppLocalizations.of(context)!;
    final periods = _getPeriods(t); // ✅ translated labels

    return Material(
      color: isDark ? theme.colorScheme.background : const Color(0xFFF2F4F8),
      elevation: overlapsContent ? 3 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: periods.map((entry) {
                // ✅ uses translated periods
                final period = entry.$1;
                final label = entry.$2;
                final isSelected = currentPeriod == period;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onPeriodChanged(period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primary
                            : (isDark
                                  ? theme.colorScheme.surface
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? primary
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.18,
                                ),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.28),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.75,
                                  ),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_PeriodFilterDelegate old) =>
      old.currentPeriod != currentPeriod || old.isDark != isDark;
}

// ─────────────────────────────────────────
// Shared pill widget (expanded header)
// ─────────────────────────────────────────
class _Pill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _Pill({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.75)),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.overline.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Error view
// ─────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
