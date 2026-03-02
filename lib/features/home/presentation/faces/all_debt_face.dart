// FILE: features/home/presentation/faces/all_debt_transactions_face.dart

import 'package:expense_mate/core/data/data_sources/local/debt_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/features/home/data/data_source/home_datasource.dart';
import 'package:expense_mate/features/home/data/repository_impl/home_repository_imp.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_debt_bloc/all_debt_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_debt_bloc/all_debt_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_debt_bloc/all_debt_state.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllDebtTransactionsFace extends StatelessWidget {
  const AllDebtTransactionsFace({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllDebtTransactionsBloc(
        repository: HomeRepositoryImp(
          homeDatasource: HomeDatasourceImp(),
          localDataSource: TransactionLocalDataSourceImpl(),
          debtDataSource: DebtLocalDataSourceImpl(),
        ),
      )..add(LoadAllDebtTransactions()),
      child: const _AllDebtTransactionsView(),
    );
  }
}

class _AllDebtTransactionsView extends StatefulWidget {
  const _AllDebtTransactionsView();

  @override
  State<_AllDebtTransactionsView> createState() =>
      _AllDebtTransactionsViewState();
}

class _AllDebtTransactionsViewState extends State<_AllDebtTransactionsView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.colorScheme.background
          : const Color(0xFFF2F4F8),
      body: BlocBuilder<AllDebtTransactionsBloc, AllDebtTransactionsState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ── Hero SliverAppBar ──
              _DebtTxSliverAppBar(
                state: state,
                isDark: isDark,
                searchController: _searchController,
              ),

              // ── 2-row pinned filter bar ──
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterBarDelegate(
                  state: state,
                  isDark: isDark,
                  onDateTap: () => _showDatePicker(context, state),
                ),
              ),

              // ── Active filters banner ──
              if (state.hasActiveFilters)
                SliverToBoxAdapter(child: _ActiveFiltersBanner(state: state)),

              // ── Content ──
              if (state.status == AllDebtTxStatus.loading)
                const SliverFillRemaining(child: _LoadingView())
              else if (state.status == AllDebtTxStatus.error)
                SliverFillRemaining(
                  child: _ErrorView(message: state.error ?? ''),
                )
              else if (state.filtered.isEmpty)
                const SliverFillRemaining(child: _EmptyView())
              else
                _DebtTxList(transactions: state.filtered),

              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext ctx,
    AllDebtTransactionsState state,
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
      ctx.read<AllDebtTransactionsBloc>().add(
        FilterDebtTxByDateRange(start: range.start, end: range.end),
      );
    }
  }
}

// ─────────────────────────────────────────
// SliverAppBar
// ─────────────────────────────────────────
class _DebtTxSliverAppBar extends StatelessWidget {
  final AllDebtTransactionsState state;
  final bool isDark;
  final TextEditingController searchController;

  const _DebtTxSliverAppBar({
    required this.state,
    required this.isDark,
    required this.searchController,
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
                      searchOpen: state.collapsedSearchOpen,
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

// ── Expanded ──
class _ExpandedHeader extends StatelessWidget {
  final AllDebtTransactionsState state;
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
                              t.debtTransaction,
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${state.filtered.length}  ${t.records}',
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchField(
                    controller: searchController,
                    onChanged: (v) => context
                        .read<AllDebtTransactionsBloc>()
                        .add(SearchDebtTransactions(v)),
                    onClear: () {
                      searchController.clear();
                      context.read<AllDebtTransactionsBloc>().add(
                        SearchDebtTransactions(''),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // Borrowed / Lent summary pills
                // expense = money I borrowed (went out), income = money I lent (came in as debt)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _SummaryPill(
                        label: t.borrowed,
                        value: '\$${_fmt(state.totalBorrowed)}',
                        icon: Icons.arrow_upward_rounded,
                        color: const Color(0xFFef4444),
                      ),
                      const SizedBox(width: 10),
                      _SummaryPill(
                        label: t.lent,
                        value: '\$${_fmt(state.totalLent)}',
                        icon: Icons.arrow_downward_rounded,
                        color: const Color(0xFF10b981),
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

// ── Collapsed ──
class _CollapsedHeader extends StatelessWidget {
  final Color primary;
  final double topPad;
  final int count;
  final TextEditingController searchController;
  final bool searchOpen;

  const _CollapsedHeader({
    required this.primary,
    required this.topPad,
    required this.count,
    required this.searchController,
    required this.searchOpen,
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
            ? Padding(
                key: const ValueKey('search'),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.read<AllDebtTransactionsBloc>().add(
                        CloseDebtTxSearch(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SearchField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: (v) => context
                            .read<AllDebtTransactionsBloc>()
                            .add(SearchDebtTransactions(v)),
                        onClear: () {
                          searchController.clear();
                          context.read<AllDebtTransactionsBloc>().add(
                            CloseDebtTxSearch(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              )
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
                        t.debtTransaction,
                        style: AppTextStyles.h5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
                    _IconBtn(
                      icon: Icons.search_rounded,
                      onTap: () => context.read<AllDebtTransactionsBloc>().add(
                        OpenDebtTxSearch(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// 2-Row Pinned Filter Bar
// Row 1: All | Borrowed | Lent  (type)
// Row 2: Cash · Card · Bank · Wallet · Date
// ─────────────────────────────────────────
class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final AllDebtTransactionsState state;
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
        height: _height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row 1: type filter
              Row(
                children: [
                  _TypeSegment(
                    label: t.all,
                    icon: Icons.grid_view_rounded,
                    isSelected: state.typeFilter == null,
                    activeColor: theme.colorScheme.primary,
                    isDark: isDark,
                    theme: theme,
                    onTap: () => context.read<AllDebtTransactionsBloc>().add(
                      FilterDebtTxByType(null),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TypeSegment(
                    label: t.borrowed,
                    icon: Icons.arrow_upward_rounded,
                    isSelected: state.typeFilter == TransactionType.expense,
                    activeColor: const Color(0xFFef4444),
                    isDark: isDark,
                    theme: theme,
                    onTap: () => context.read<AllDebtTransactionsBloc>().add(
                      FilterDebtTxByType(TransactionType.expense),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TypeSegment(
                    label: t.lent,
                    icon: Icons.arrow_downward_rounded,
                    isSelected: state.typeFilter == TransactionType.income,
                    activeColor: const Color(0xFF10b981),
                    isDark: isDark,
                    theme: theme,
                    onTap: () => context.read<AllDebtTransactionsBloc>().add(
                      FilterDebtTxByType(TransactionType.income),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Row 2: payment method + date
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
                        padding: const EdgeInsets.only(right: 8),
                        child: _MethodPill(
                          method: m,
                          isSelected: state.methodFilter == m,
                          isDark: isDark,
                          theme: theme,
                          context: context,
                          onTap: () =>
                              context.read<AllDebtTransactionsBloc>().add(
                                state.methodFilter == m
                                    ? FilterDebtTxByMethod(null)
                                    : FilterDebtTxByMethod(m),
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
                      onClear: () => context
                          .read<AllDebtTransactionsBloc>()
                          .add(FilterDebtTxByDateRange()),
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

// ─────────────────────────────────────────
// Transaction list + card
// ─────────────────────────────────────────
class _DebtTxList extends StatelessWidget {
  final List<TransactionModel> transactions;
  const _DebtTxList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _DebtTxCard(transaction: transactions[index]),
          childCount: transactions.length,
        ),
      ),
    );
  }
}

class _DebtTxCard extends StatelessWidget {
  final TransactionModel transaction;
  const _DebtTxCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // expense = I borrowed (money went out), income = I lent (money came in as debt)
    final isBorrowed = transaction.type == TransactionType.expense;
    final color = isBorrowed
        ? const Color(0xFFef4444)
        : const Color(0xFF10b981);
    final firstItem = transaction.items.isNotEmpty
        ? transaction.items.first
        : null;

    // Lookup linked debt person name via bloc repo
    final bloc = context.read<AllDebtTransactionsBloc>();
    final linkedDebt = transaction.debtId != null
        ? bloc.repository.getLinkedDebt(transaction.debtId!)
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
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isBorrowed
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Person name if available, else category
                Text(
                  linkedDebt?.personName ??
                      context.tr(firstItem?.category ?? t.debtTransaction),
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // Debt type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isBorrowed ? t.borrowed : t.lent,
                        style: AppTextStyles.overline.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _methodIcon(transaction.paymentMethod),
                      size: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${_methodLabel(transaction.paymentMethod, context)} · ${DateFormat('MMM d, y').format(transaction.date)}',
                      style: AppTextStyles.captionSmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                // Due date if linked debt exists
                if (linkedDebt != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        linkedDebt.isOverdue
                            ? Icons.warning_amber_rounded
                            : Icons.event_rounded,
                        size: 11,
                        color: linkedDebt.isOverdue
                            ? const Color(0xFFef4444)
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        linkedDebt.isOverdue
                            ? '${linkedDebt.daysOverdue}d overdue'
                            : '${t.due} ${DateFormat('MMM d').format(linkedDebt.expectedReturnDate)}',
                        style: AppTextStyles.overline.copyWith(
                          color: linkedDebt.isOverdue
                              ? const Color(0xFFef4444)
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.45,
                                ),
                          fontWeight: linkedDebt.isOverdue
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Settled badge
                      if (linkedDebt.isReturned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10b981,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            t.settled,
                            style: AppTextStyles.overline.copyWith(
                              color: const Color(0xFF10b981),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Amount
          Text(
            '${isBorrowed ? '-' : '+'}\$${NumberFormat('#,##0.00').format(transaction.totalAmount)}',
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

  String _methodLabel(PaymentMethod m, BuildContext context) =>
      context.trMethod(m.name);
}

// ─────────────────────────────────────────
// Shared filter widgets
// ─────────────────────────────────────────
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
    // final label = method.name[0].toUpperCase() + method.name.substring(1);
    final label = context.trMethod(method.name);
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
    final t = AppLocalizations.of(context)!;
    final isSelected = dateStart != null;
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
// Active filters banner
// ─────────────────────────────────────────
class _ActiveFiltersBanner extends StatelessWidget {
  final AllDebtTransactionsState state;
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
            '${state.filtered.length}  ${t.records}${state.filtered.length == 1 ? '' : 's'}',
            style: AppTextStyles.labelSmall.copyWith(color: primary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.read<AllDebtTransactionsBloc>().add(
              ClearDebtTxFilters(),
            ),
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
// Reusable widgets
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
          hintText: t.searchByPerson,
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
              Icons.handshake_outlined,
              size: 38,
              color: primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            t.noDebtTransactions,
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
