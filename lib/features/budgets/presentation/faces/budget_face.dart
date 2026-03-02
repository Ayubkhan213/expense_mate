import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_state.dart';
import 'package:expense_mate/features/budgets/presentation/components/budget_card.dart';
import 'package:expense_mate/features/budgets/presentation/faces/budget_details.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';

class BudgetsFace extends StatelessWidget {
  const BudgetsFace({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BudgetBloc>().add(LoadBudgetsEvent());
    return const _BudgetsFaceView();
  }
}

// ── StatefulWidget only to hold TextEditingController (no setState) ──
class _BudgetsFaceView extends StatefulWidget {
  const _BudgetsFaceView();

  @override
  State<_BudgetsFaceView> createState() => _BudgetsFaceViewState();
}

class _BudgetsFaceViewState extends State<_BudgetsFaceView> {
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
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          const expandedHeight = 270.0;

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              _BudgetSliverAppBar(
                state: state,
                isDark: isDark,
                expandedHeight: expandedHeight,
                searchController: _searchController,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterHeaderDelegate(state: state, isDark: isDark),
              ),
              // Search result count banner
              if (state.searchQuery.isNotEmpty)
                SliverToBoxAdapter(child: _SearchBanner(state: state)),
              if (state.status == BudgetStatus.loading)
                const SliverFillRemaining(child: _LoadingView())
              else if (state.status == BudgetStatus.error)
                SliverFillRemaining(
                  child: _ErrorView(message: state.errorMessage),
                )
              else if (state.filteredBudgets.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      _EmptyView(filter: state.activeFilter),
                      SizedBox(height: expandedHeight),
                    ],
                  ),
                )
              else
                _BudgetList(budgets: state.filteredBudgets),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// SliverAppBar
// ─────────────────────────────────────────
class _BudgetSliverAppBar extends StatelessWidget {
  final BudgetState state;
  final bool isDark;
  final double expandedHeight;
  final TextEditingController searchController;

  const _BudgetSliverAppBar({
    required this.state,
    required this.isDark,
    required this.expandedHeight,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bgColor = isDark ? theme.colorScheme.surface : Colors.white;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;

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

          return Stack(
            fit: StackFit.expand,
            children: [
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
                    state: state,
                    bgColor: bgColor,
                    primary: primary,
                    topPad: topPad,
                    theme: theme,
                    searchController: searchController,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ── Expanded header ──
class _ExpandedHeader extends StatelessWidget {
  final BudgetState state;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state.searchOpen) ...[
                        _IconBtn(
                          icon: Icons.arrow_back_rounded,
                          onTap: () {
                            searchController.clear();
                            context.read<BudgetBloc>().add(
                              BudgetSearchClosed(),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SearchField(
                            key: const ValueKey('search'),
                            controller: searchController,
                            autofocus: true,
                            onChanged: (v) => context.read<BudgetBloc>().add(
                              BudgetSearchChanged(v),
                            ),
                            onClose: () {
                              searchController.clear();
                              context.read<BudgetBloc>().add(
                                BudgetSearchClosed(),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.myBudgets,
                                style: AppTextStyles.h2.copyWith(
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${state.activeBudgets.length} ${t.active} · ${state.budgets.length} ${t.total}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 12.0),
                        ),
                        _IconBtn(
                          icon: Icons.search_rounded,
                          onTap: () => context.read<BudgetBloc>().add(
                            BudgetSearchOpened(),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SummaryCard(state: state),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Collapsed header ──
class _CollapsedHeader extends StatelessWidget {
  final BudgetState state;
  final Color bgColor;
  final Color primary;
  final double topPad;
  final ThemeData theme;
  final TextEditingController searchController;

  const _CollapsedHeader({
    required this.state,
    required this.bgColor,
    required this.primary,
    required this.topPad,
    required this.theme,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: topPad),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: state.searchOpen
            ? Padding(
                key: const ValueKey('search'),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: () {
                        searchController.clear();
                        context.read<BudgetBloc>().add(BudgetSearchClosed());
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SearchField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: (v) => context.read<BudgetBloc>().add(
                          BudgetSearchChanged(v),
                        ),
                        onClose: () {
                          searchController.clear();
                          context.read<BudgetBloc>().add(BudgetSearchClosed());
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              )
            : Padding(
                key: const ValueKey('title'),
                padding: const EdgeInsets.only(left: 22, right: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        t.myBudgets,
                        style: AppTextStyles.h5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _IconBtn(
                      icon: Icons.search_rounded,
                      onTap: () =>
                          context.read<BudgetBloc>().add(BudgetSearchOpened()),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Pinned filter tab bar
// ─────────────────────────────────────────
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final BudgetState state;
  final bool isDark;

  _FilterHeaderDelegate({required this.state, required this.isDark});

  static const double _height = 56.0;

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
    return Material(
      color: isDark ? theme.colorScheme.background : const Color(0xFFF2F4F8),
      elevation: overlapsContent ? 3 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              // BudgetFilter.values is now [all, active, expired, archived]
              // so All comes first automatically
              children: BudgetFilter.values.map((filter) {
                final isSelected = state.activeFilter == filter;
                final count = _countFor(filter, state);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    filter: filter,
                    count: count,
                    isSelected: isSelected,
                    isDark: isDark,
                    theme: theme,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  static int _countFor(BudgetFilter filter, BudgetState state) {
    switch (filter) {
      case BudgetFilter.all:
        return state.budgets.length;
      case BudgetFilter.active:
        return state.activeBudgets.length;
      case BudgetFilter.expired:
        return state.expiredBudgets.length;
      case BudgetFilter.archived:
        return state.archivedBudgets.length;
    }
  }

  @override
  bool shouldRebuild(_FilterHeaderDelegate old) =>
      old.state != state || old.isDark != isDark;
}

class _FilterChip extends StatelessWidget {
  final BudgetFilter filter;
  final int count;
  final bool isSelected;
  final bool isDark;
  final ThemeData theme;

  const _FilterChip({
    required this.filter,
    required this.count,
    required this.isSelected,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    return GestureDetector(
      onTap: () => context.read<BudgetBloc>().add(BudgetFilterChanged(filter)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? primary
              : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? primary
                : theme.colorScheme.outline.withValues(alpha: 0.18),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
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
            Icon(_icon, size: 13, color: isSelected ? Colors.white : primary),
            const SizedBox(width: 6),
            Text(
              _getLabel(context),
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 7),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.22)
                    : primary.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: AppTextStyles.overline.copyWith(
                  color: isSelected ? Colors.white : primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (filter) {
      case BudgetFilter.all:
        return Icons.grid_view_rounded;
      case BudgetFilter.active:
        return Icons.trending_up_rounded;
      case BudgetFilter.expired:
        return Icons.event_busy_rounded;
      case BudgetFilter.archived:
        return Icons.archive_rounded;
    }
  }

  String _getLabel(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (filter) {
      case BudgetFilter.all:
        return t.all;
      case BudgetFilter.active:
        return t.active;
      case BudgetFilter.expired:
        return t.expired;
      case BudgetFilter.archived:
        return t.archived;
    }
  }
}

// ─────────────────────────────────────────
// Search result banner
// ─────────────────────────────────────────
class _SearchBanner extends StatelessWidget {
  final BudgetState state;
  const _SearchBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 13, color: primary),
          const SizedBox(width: 5),
          Text(
            '"${state.searchQuery}" · ${state.filteredBudgets.length} result${state.filteredBudgets.length == 1 ? '' : 's'}',
            style: AppTextStyles.labelSmall.copyWith(color: primary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.read<BudgetBloc>().add(BudgetSearchClosed()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primary.withValues(alpha: 0.25)),
              ),
              child: Text(
                'Clear',
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
// Search field (glass style)
// ─────────────────────────────────────────
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;
  final bool autofocus;

  const _SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClose,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return TextField(
            controller: controller,
            autofocus: autofocus,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search budgets…',
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.white.withValues(alpha: 0.65),
                size: 17,
              ),
              suffixIcon: value.text.isNotEmpty
                  ? GestureDetector(
                      onTap: onClose,
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withValues(alpha: 0.65),
                        size: 17,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// Remaining widgets (unchanged from original)
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

class _SummaryCard extends StatelessWidget {
  final BudgetState state;
  const _SummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final totalBudgeted = state.activeBudgets.fold<double>(
      0,
      (s, b) => s + b.totalAmount,
    );
    final totalSpent = state.activeBudgets.fold<double>(
      0,
      (s, b) => s + b.spentAmount,
    );
    final totalRemaining = totalBudgeted - totalSpent;
    final progress = totalBudgeted > 0
        ? (totalSpent / totalBudgeted).clamp(0.0, 1.0)
        : 0.0;
    final isOver = totalSpent > totalBudgeted;

    return Container(
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
                    t.totalRemaining,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${totalRemaining.abs().toStringAsFixed(0)}',
                    style: AppTextStyles.currencyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${t.ofa} \$${totalBudgeted.toStringAsFixed(0)}',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOver
                          ? Colors.red.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isOver
                          ? t.overBudget
                          : '${(progress * 100).toStringAsFixed(0)}% ${t.used}',
                      style: AppTextStyles.overline.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOver ? const Color(0xFFFF6B6B) : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Pill(
                label: t.spent,
                value: '\$${totalSpent.toStringAsFixed(0)}',
                icon: Icons.arrow_upward_rounded,
              ),
              const SizedBox(width: 10),
              _Pill(
                label: t.budgets,
                value: '${state.activeBudgets.length} ${t.active}',
                icon: Icons.account_balance_wallet_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

class _BudgetList extends StatelessWidget {
  final List<BudgetModel> budgets;
  const _BudgetList({required this.budgets});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BudgetCard(
              budget: budgets[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BudgetDetailsFace(budget: budgets[index]),
                ),
              ),
            ),
          ),
          childCount: budgets.length,
        ),
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
  final BudgetFilter filter;
  const _EmptyView({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final (icon, title, subtitle) = switch (filter) {
      BudgetFilter.all => (
        Icons.wallet,
        'No budgets yet',
        'Create your first budget below',
      ),
      BudgetFilter.active => (
        Icons.add_card_rounded,
        'No active budgets',
        'Tap "New Budget" to get started',
      ),
      BudgetFilter.expired => (
        Icons.event_busy_rounded,
        'No expired budgets',
        'All your budgets are on track!',
      ),
      BudgetFilter.archived => (
        Icons.archive_rounded,
        'Nothing archived',
        'Archived budgets will show here',
      ),
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: primary.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: AppTextStyles.h5.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? message;
  const _ErrorView({this.message});

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
              size: 56,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Something went wrong',
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () =>
                  context.read<BudgetBloc>().add(LoadBudgetsEvent()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text('Retry', style: AppTextStyles.labelLarge),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
