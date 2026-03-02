import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart';
import 'package:expense_mate/features/recurring/data/repositort_imp/recurring_repo_impl.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring_detail/recurring_detail_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring_detail/recurring_detail_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring_detail/recurring_detail_state.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_detail_info.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_detail_monthly_estimate.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_detail_stats.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_generated_transactions_list.dart';
import 'package:expense_mate/features/recurring/presentation/faces/recurring_bottomsheet.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecurringDetailPage extends StatelessWidget {
  final String recurringId;

  const RecurringDetailPage({super.key, required this.recurringId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecurringDetailBloc(
        repository: RecurringRepositoryImpl(
          localDataSource: RecurringLocalDataSourceImpl(),
        ),
      )..add(LoadRecurringDetail(recurringId)),
      child: const _RecurringDetailView(),
    );
  }
}

class _RecurringDetailView extends StatelessWidget {
  const _RecurringDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.colorScheme.background
          : const Color(0xFFF2F4F8),
      body: BlocBuilder<RecurringDetailBloc, RecurringDetailState>(
        builder: (context, state) {
          if (state is RecurringDetailLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 2.5,
              ),
            );
          }

          if (state is RecurringDetailError) {
            return _ErrorView(message: state.message);
          }

          if (state is RecurringDetailLoaded) {
            return _LoadedView(state: state, isDark: isDark);
          }

          return const SizedBox();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// Main loaded view with DefaultTabController
// ─────────────────────────────────────────
class _LoadedView extends StatelessWidget {
  final RecurringDetailLoaded state;
  final bool isDark;

  const _LoadedView({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isIncome = state.recurring.type == TransactionType.income;

    return DefaultTabController(
      length: 2,
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<RecurringDetailBloc>().add(
            RefreshRecurringDetail(state.recurring.id),
          );
        },
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            // ── Hero SliverAppBar ──
            _DetailSliverAppBar(
              state: state,
              isDark: isDark,
              isIncome: isIncome,
            ),

            // ── Pinned Tab Bar ──
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(isDark: isDark),
            ),

            // ── Tab Content ──
            _TabContent(state: state, isDark: isDark, isIncome: isIncome),

            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SliverAppBar
// ─────────────────────────────────────────
class _DetailSliverAppBar extends StatelessWidget {
  final RecurringDetailLoaded state;
  final bool isDark;
  final bool isIncome;

  const _DetailSliverAppBar({
    required this.state,
    required this.isDark,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;
    const expandedHeight = 280.0;

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
                      isIncome: isIncome,
                      topPad: topPad,
                      availableHeight: current,
                    ),
                  ),
                if (collapsedOpacity > 0)
                  Opacity(
                    opacity: collapsedOpacity,
                    child: _CollapsedHeader(
                      primary: primary,
                      topPad: topPad,
                      state: state,
                      isIncome: isIncome,
                      context: context,
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
  final RecurringDetailLoaded state;
  final Color primary;
  final bool isIncome;
  final double topPad;
  final double availableHeight;

  const _ExpandedHeader({
    required this.state,
    required this.primary,
    required this.isIncome,
    required this.topPad,
    required this.availableHeight,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isIncome
        ? const Color(0xFF10b981)
        : const Color(0xFFef4444);

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
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Top bar: back + edit ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      _IconBtn(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      _IconBtn(
                        icon: Icons.edit_rounded,
                        onTap: () => _showEditSheet(context, state.recurring),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Icon + category ──
                Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isIncome
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: accentColor,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      context.tr(state.recurring.categoryKey).toUpperCase(),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ── Amount ──
                    Text(
                      '${isIncome ? '+' : '-'}\$${state.recurring.amount.toStringAsFixed(2)}',
                      style: AppTextStyles.currencyLarge.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── Status + frequency pills ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatusPill(isActive: state.recurring.isActive),
                        const SizedBox(width: 8),
                        _FrequencyPill(frequency: state.recurring.frequency),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, RecurringTransactionModel r) {
    final category = CategoryHiveModel(
      key: r.categoryKey,
      isIncome: r.type == TransactionType.income,
      colorValue: 0xFF6200EA,
      iconCode: Icons.category.codePoint,
    );
    RecurringTransactionBottomSheet.show(
      context,
      category,
      existingRecurring: r,
    );
  }
}

// ── Collapsed header ──
class _CollapsedHeader extends StatelessWidget {
  final Color primary;
  final double topPad;
  final RecurringDetailLoaded state;
  final bool isIncome;
  final BuildContext context;

  const _CollapsedHeader({
    required this.primary,
    required this.topPad,
    required this.state,
    required this.isIncome,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    final accentColor = isIncome
        ? const Color(0xFF10b981)
        : const Color(0xFFef4444);

    return Container(
      color: primary,
      padding: EdgeInsets.only(top: topPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4),
          _IconBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(state.recurring.categoryKey).toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '${isIncome ? '+' : '-'}\$${state.recurring.amount.toStringAsFixed(2)}',
                  style: AppTextStyles.h5.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _IconBtn(
            icon: Icons.edit_rounded,
            onTap: () {
              final category = CategoryHiveModel(
                key: state.recurring.categoryKey,
                isIncome: state.recurring.type == TransactionType.income,
                colorValue: 0xFF6200EA,
                iconCode: Icons.category.codePoint,
              );
              RecurringTransactionBottomSheet.show(
                context,
                category,
                existingRecurring: state.recurring,
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Pinned Tab Bar
// ─────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final bool isDark;
  const _TabBarDelegate({required this.isDark});

  static const double _height = 52.0;

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
    return Material(
      color: isDark ? theme.colorScheme.background : const Color(0xFFF2F4F8),
      elevation: overlapsContent ? 3 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.6,
            ),
            labelStyle: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_rounded, size: 14),
                    SizedBox(width: 6),
                    Text(t.ledger),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insights_rounded, size: 14),
                    SizedBox(width: 6),
                    Text(t.insights),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.isDark != isDark;
}

// ─────────────────────────────────────────
// Tab Content via SliverFillRemaining
// ─────────────────────────────────────────
class _TabContent extends StatelessWidget {
  final RecurringDetailLoaded state;
  final bool isDark;
  final bool isIncome;

  const _TabContent({
    required this.state,
    required this.isDark,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: TabBarView(
        children: [
          // ── Tab 1: Ledger (transactions) ──
          _LedgerTab(state: state),

          // ── Tab 2: Insights (details + stats + estimate) ──
          _InsightsTab(state: state, isIncome: isIncome),
        ],
      ),
    );
  }
}

class _LedgerTab extends StatelessWidget {
  final RecurringDetailLoaded state;
  const _LedgerTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: RecurringGeneratedTransactionsList(
        transactions: state.generatedTransactions,
      ),
    );
  }
}

class _InsightsTab extends StatelessWidget {
  final RecurringDetailLoaded state;
  final bool isIncome;
  const _InsightsTab({required this.state, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          RecurringDetailStats(
            transactionCount: state.generatedTransactions.length,
            totalSpent: state.totalSpent,
            isIncome: isIncome,
          ),
          const SizedBox(height: 12),
          RecurringDetailMonthlyEstimate(
            monthlyAmount: state.monthlyEstimate,
            isIncome: isIncome,
          ),
          const SizedBox(height: 12),
          RecurringDetailInfo(transaction: state.recurring),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isActive;
  const _StatusPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF10b981).withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? const Color(0xFF10b981).withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF10b981)
                  : Colors.white.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? t.active : t.pause,
            style: AppTextStyles.overline.copyWith(
              color: isActive
                  ? const Color(0xFF10b981)
                  : Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrequencyPill extends StatelessWidget {
  final RecurrenceFrequency frequency;
  const _FrequencyPill({required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.repeat_rounded,
            size: 11,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 5),
          Text(
            _getLabel(context),
            style: AppTextStyles.overline.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getLabel(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return t.daily;
      case RecurrenceFrequency.weekly:
        return t.weekly;
      case RecurrenceFrequency.biweekly:
        return t.biweekly;
      case RecurrenceFrequency.monthly:
        return t.monthly;
      case RecurrenceFrequency.quarterly:
        return t.quarterly;
      case RecurrenceFrequency.yearly:
        return t.yearly;
    }
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Color(0xFFef4444),
          ),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
