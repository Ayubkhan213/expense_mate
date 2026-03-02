import 'package:expense_mate/core/data/data_sources/local/debt_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/features/home/data/data_source/home_datasource.dart';
import 'package:expense_mate/features/home/data/repository_impl/home_repository_imp.dart';

import 'package:expense_mate/features/home/presentation/bloc/all_transcation_bloc/all_transcation_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_transcation_bloc/all_transcation_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_transcation_bloc/all_transcation_state.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllTransactionsFace extends StatelessWidget {
  const AllTransactionsFace({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllTransactionsBloc(
        repository: HomeRepositoryImp(
          homeDatasource: HomeDatasourceImp(),
          localDataSource: TransactionLocalDataSourceImpl(),
          debtDataSource: DebtLocalDataSourceImpl(),
        ),
      )..add(LoadAllTransactions()),
      child: const _AllTransactionsView(),
    );
  }
}

class _AllTransactionsView extends StatefulWidget {
  const _AllTransactionsView();

  @override
  State<_AllTransactionsView> createState() => _AllTransactionsViewState();
}

class _AllTransactionsViewState extends State<_AllTransactionsView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCollapsedSearch() {
    context.read<AllTransactionsBloc>().add(OpenCollapsedSearch());
  }

  void _closeCollapsedSearch() {
    _searchController.clear();
    context.read<AllTransactionsBloc>().add(CloseCollapsedSearch());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.colorScheme.background
          : const Color(0xFFF2F4F8),
      body: BlocBuilder<AllTransactionsBloc, AllTransactionsState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              _AllTransactionsSliverAppBar(
                state: state,
                isDark: isDark,
                searchController: _searchController,
                collapsedSearchOpen: state.collapsedSearchOpen,
                onOpenSearch: _openCollapsedSearch,
                onCloseSearch: _closeCollapsedSearch,
              ),

              // 2-row pinned filter bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterBarDelegate(
                  state: state,
                  isDark: isDark,
                  onDateTap: () => _showDatePicker(context, state),
                ),
              ),

              // Active filters banner
              if (state.hasActiveFilters)
                SliverToBoxAdapter(child: _ActiveFiltersBanner(state: state)),

              // Content
              if (state.status == AllTransactionsStatus.loading)
                const SliverFillRemaining(child: _LoadingView())
              else if (state.status == AllTransactionsStatus.error)
                SliverFillRemaining(
                  child: _ErrorView(message: state.error ?? ''),
                )
              else if (state.filtered.isEmpty)
                const SliverFillRemaining(child: _EmptyView())
              else
                _TransactionList(transactions: state.filtered),

              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext ctx,
    AllTransactionsState state,
  ) async {
    final range = await showDateRangePicker(
      context: ctx,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: state.dateStart != null && state.dateEnd != null
          ? DateTimeRange(start: state.dateStart!, end: state.dateEnd!)
          : null,
    );
    if (range != null && mounted) {
      ctx.read<AllTransactionsBloc>().add(
        FilterByDateRange(start: range.start, end: range.end),
      );
    }
  }
}

// ─────────────────────────────────────────
// SliverAppBar
// ─────────────────────────────────────────
class _AllTransactionsSliverAppBar extends StatelessWidget {
  final AllTransactionsState state;
  final bool isDark;
  final TextEditingController searchController;
  final bool collapsedSearchOpen;
  final VoidCallback onOpenSearch;
  final VoidCallback onCloseSearch;

  const _AllTransactionsSliverAppBar({
    required this.state,
    required this.isDark,
    required this.searchController,
    required this.collapsedSearchOpen,
    required this.onOpenSearch,
    required this.onCloseSearch,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;
    const expandedHeight = 230.0;

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
                      searchController: searchController,
                    ),
                  ),
                if (collapsedOpacity > 0)
                  Opacity(
                    opacity: collapsedOpacity,
                    child: _CollapsedHeader(
                      primary: primary,
                      topPad: topPad,
                      count: state.filtered.length,
                      searchController: searchController,
                      searchOpen: collapsedSearchOpen,
                      onOpenSearch: onOpenSearch,
                      onCloseSearch: onCloseSearch,
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

// ── Expanded: gradient + search bar + pills ──
class _ExpandedHeader extends StatelessWidget {
  final AllTransactionsState state;
  final Color primary;
  final double topPad;
  final double availableHeight;
  final TextEditingController searchController;

  const _ExpandedHeader({
    required this.state,
    required this.primary,
    required this.topPad,
    required this.availableHeight,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final totalIncome = state.filtered
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (s, t) => s + t.totalAmount);
    final totalExpense = state.filtered
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (s, t) => s + t.totalAmount);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                  child: Row(
                    children: [
                      _IconBtn(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.allTransactions,
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${state.filtered.length} ${t.records}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchField(
                    controller: searchController,
                    onChanged: (v) => context.read<AllTransactionsBloc>().add(
                      SearchTransactions(v),
                    ),
                    onClear: () {
                      searchController.clear();
                      context.read<AllTransactionsBloc>().add(
                        SearchTransactions(''),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // Income / Expense pills
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _SummaryPill(
                        label: t.income,
                        value: '\$${_fmt(totalIncome)}',
                        icon: Icons.arrow_downward_rounded,
                        color: const Color(0xFF10b981),
                      ),
                      const SizedBox(width: 10),
                      _SummaryPill(
                        label: t.expense,
                        value: '\$${_fmt(totalExpense)}',
                        icon: Icons.arrow_upward_rounded,
                        color: const Color(0xFFef4444),
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

  String _fmt(double a) => NumberFormat('#,##0.00').format(a);
}

// ── Collapsed: title + search icon → expands to search field ──
class _CollapsedHeader extends StatelessWidget {
  final Color primary;
  final double topPad;
  final int count;
  final TextEditingController searchController;
  final bool searchOpen;
  final VoidCallback onOpenSearch;
  final VoidCallback onCloseSearch;

  const _CollapsedHeader({
    required this.primary,
    required this.topPad,
    required this.count,
    required this.searchController,
    required this.searchOpen,
    required this.onOpenSearch,
    required this.onCloseSearch,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      color: primary,
      padding: EdgeInsets.only(top: topPad),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: searchOpen
            // ─ Search mode ─
            ? Padding(
                key: const ValueKey('search'),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: onCloseSearch,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SearchField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: (v) => context
                            .read<AllTransactionsBloc>()
                            .add(SearchTransactions(v)),
                        onClear: onCloseSearch,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              )
            // ─ Normal mode ─
            : Padding(
                key: const ValueKey('normal'),
                padding: const EdgeInsets.only(left: 4, right: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        t.allTransactions,
                        style: AppTextStyles.h5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Record count badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: AppTextStyles.overline.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search icon — tap to open search field
                    _IconBtn(icon: Icons.search_rounded, onTap: onOpenSearch),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 2-Row Pinned Filter Bar
// Row 1: [All] [Income] [Expense]  — full width, equal segments
// Row 2: Cash · Card · Bank · Wallet · Date Range — horizontal scroll
// ─────────────────────────────────────────
class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final AllTransactionsState state;
  final bool isDark;
  final VoidCallback onDateTap;

  _FilterBarDelegate({
    required this.state,
    required this.isDark,
    required this.onDateTap,
  });

  static const double _height = 104.0;

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
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Material(
      color: isDark ? theme.colorScheme.background : const Color(0xFFF2F4F8),
      elevation: overlapsContent ? 3 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: SizedBox(
        height: 104.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Row 1: Type — equal-width segments ──
              Row(
                children: [
                  _TypeSegment(
                    label: t.all,
                    icon: Icons.grid_view_rounded,
                    isSelected: state.typeFilter == null,
                    activeColor: theme.colorScheme.primary,
                    isDark: isDark,
                    theme: theme,
                    onTap: () => context.read<AllTransactionsBloc>().add(
                      FilterByType(null),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TypeSegment(
                    label: t.income,
                    icon: Icons.arrow_downward_rounded,
                    isSelected: state.typeFilter == TransactionType.income,
                    activeColor: const Color(0xFF10b981),
                    isDark: isDark,
                    theme: theme,
                    onTap: () => context.read<AllTransactionsBloc>().add(
                      FilterByType(TransactionType.income),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TypeSegment(
                    label: t.expense,
                    icon: Icons.arrow_upward_rounded,
                    isSelected: state.typeFilter == TransactionType.expense,
                    activeColor: const Color(0xFFef4444),
                    isDark: isDark,
                    theme: theme,
                    onTap: () => context.read<AllTransactionsBloc>().add(
                      FilterByType(TransactionType.expense),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Row 2: Method + Date — horizontal scroll pills ──
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...[
                      PaymentMethod.cash,
                      PaymentMethod.card,
                      PaymentMethod.bank,
                      PaymentMethod.wallet,
                    ].map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                        child: _MethodPill(
                          method: m,
                          isSelected: state.methodFilter == m,
                          isDark: isDark,
                          theme: theme,
                          context: context,
                          onTap: () => context.read<AllTransactionsBloc>().add(
                            state.methodFilter == m
                                ? FilterByPaymentMethod(null)
                                : FilterByPaymentMethod(m),
                          ),
                        ),
                      ),
                    ),
                    _DatePill(
                      dateStart: state.dateStart,
                      dateEnd: state.dateEnd,
                      isDark: isDark,
                      theme: theme,
                      onTap: onDateTap,
                      onClear: () => context.read<AllTransactionsBloc>().add(
                        FilterByDateRange(),
                      ),
                    ),
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
  bool shouldRebuild(_FilterBarDelegate old) =>
      old.state != state || old.isDark != isDark;
}

// Row 1 chip — full-width equal segment
class _TypeSegment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;

  const _TypeSegment({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.isDark,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          height: 42,
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor
                : (isDark ? theme.colorScheme.surface : Colors.white),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isSelected
                  ? activeColor
                  : theme.colorScheme.outline.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.32),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Row 2 pill — payment method
class _MethodPill extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;
  final BuildContext context;

  const _MethodPill({
    required this.method,
    required this.isSelected,
    required this.isDark,
    required this.theme,
    required this.onTap,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final label = context.trMethod(method.name);
    // final label = method.name[0].toUpperCase() + method.name.substring(1);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primary
              : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? primary
                : theme.colorScheme.outline.withValues(alpha: 0.15),
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
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icon,
              size: 13,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money_rounded;
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.bank:
        return Icons.account_balance_rounded;
      case PaymentMethod.wallet:
        return Icons.account_balance_wallet_rounded;
    }
  }
}

// Row 2 pill — date range
class _DatePill extends StatelessWidget {
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DatePill({
    required this.dateStart,
    required this.dateEnd,
    required this.isDark,
    required this.theme,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final isSelected = dateStart != null;
    final t = AppLocalizations.of(context)!;
    final label = isSelected
        ? '${DateFormat('MMM d').format(dateStart!)} – ${DateFormat('MMM d').format(dateEnd!)}'
        : t.dateRange;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primary
              : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? primary
                : theme.colorScheme.outline.withValues(alpha: 0.15),
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
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 13,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Active filter banner
// ─────────────────────────────────────────
class _ActiveFiltersBanner extends StatelessWidget {
  final AllTransactionsState state;
  const _ActiveFiltersBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        children: [
          Icon(Icons.filter_alt_rounded, size: 13, color: primary),
          const SizedBox(width: 5),
          Text(
            '${state.filtered.length} result${state.filtered.length == 1 ? '' : 's'}',
            style: AppTextStyles.labelSmall.copyWith(color: primary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                context.read<AllTransactionsBloc>().add(ClearFilters()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primary.withValues(alpha: 0.25)),
              ),
              child: Text(
                t.clearAll,
                style: AppTextStyles.overline.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Reusable search field (white glass style)
// ─────────────────────────────────────────
class _SearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool autofocus;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.autofocus = false,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autofocus,
        style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: t.searchByCategory,
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.65),
            size: 18,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: widget.onClear,
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white.withValues(alpha: 0.65),
                    size: 18,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

// ─────────────────────────────────────────
// Transaction list + card
// ─────────────────────────────────────────
class _TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              _TransactionCard(transaction: transactions[index]),
          childCount: transactions.length,
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? const Color(0xFF10b981) : const Color(0xFFef4444);
    final firstItem = transaction.items.isNotEmpty
        ? transaction.items.first
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(firstItem?.category ?? t.transactions),
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      _methodIcon(transaction.paymentMethod),
                      size: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_methodLabel(transaction.paymentMethod)} · ${DateFormat('MMM d, y').format(transaction.date)}',
                      style: AppTextStyles.captionSmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    if (transaction.items.length > 1) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+${transaction.items.length - 1}',
                          style: AppTextStyles.overline.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${NumberFormat('#,##0.00').format(transaction.totalAmount)}',
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  IconData _methodIcon(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return Icons.money_rounded;
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.bank:
        return Icons.account_balance_rounded;
      case PaymentMethod.wallet:
        return Icons.account_balance_wallet_rounded;
    }
  }

  String _methodLabel(PaymentMethod m) =>
      m.name[0].toUpperCase() + m.name.substring(1);
}

// ─────────────────────────────────────────
// Shared summary pill (in expanded header)
// ─────────────────────────────────────────
class _SummaryPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

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
          Icon(icon, size: 13, color: color),
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
// Shared icon button (white glass)
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

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).colorScheme.primary,
      strokeWidth: 2.5,
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 38,
              color: primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            t.noTransactions,
            style: AppTextStyles.h5.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            t.tryAdjustingFilters,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      message,
      style: AppTextStyles.bodyMedium.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
  );
}
