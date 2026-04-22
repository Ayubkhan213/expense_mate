import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/extension/responsive_extension.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/features/recurring/presentation/bloc/recurring/recurring_bloc.dart';
import 'package:spendio/features/recurring/presentation/bloc/recurring/recurring_list_event.dart';
import 'package:spendio/features/recurring/presentation/bloc/recurring/recurring_list_state.dart';
import 'package:spendio/features/recurring/presentation/component/recurring_component/recurring_transaction_card.dart';
import 'package:spendio/features/recurring/presentation/component/recurring_component/recurring_empty_state.dart';
import 'package:spendio/features/recurring/presentation/faces/recurring_bottomsheet.dart';
import 'package:spendio/features/recurring/presentation/faces/recurring_category_selection.dart';
import 'package:spendio/features/recurring/presentation/faces/recurring_detail.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/recurring_component/recurring_filter_chips.dart';

// StatefulWidget only to hold TextEditingController — zero setState calls
class RecurringFace extends StatefulWidget {
  const RecurringFace({super.key});
  @override
  State<RecurringFace> createState() => _RecurringFaceState();
}

class _RecurringFaceState extends State<RecurringFace> {
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
      body: BlocConsumer<RecurringListBloc, RecurringListState>(
        listener: (context, state) {
          if (state is RecurringListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is RecurringListOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RecurringListLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 2.5,
              ),
            );
          }
          if (state is RecurringListError) {
            return Center(child: Text(state.message));
          }
          if (state is RecurringListLoaded) {
            return _buildBody(context, state, isDark);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    RecurringListLoaded state,
    bool isDark,
  ) {
    final translate = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<RecurringListBloc>().add(LoadRecurringList()),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _RecurringSliverAppBar(
            state: state,
            isDark: isDark,
            searchController: _searchController,
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _RecurringFilterDelegate(
              currentFilter: state.currentFilter,
              onFilterChanged: (f) =>
                  context.read<RecurringListBloc>().add(FilterRecurringList(f)),
              isDark: isDark,
            ),
          ),
          if (state.searchQuery.isNotEmpty)
            SliverToBoxAdapter(child: _SearchBanner(state: state)),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          if (state.all.isEmpty)
            SliverFillRemaining(
              child: RecurringEmptyState(
                onAddPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecurringCategorySelector(),
                  ),
                ),
              ),
            )
          else if (state.filtered.isEmpty)
            const SliverFillRemaining(child: _EmptyFilterView())
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final t = state.filtered[i];
                  return RecurringTransactionCard(
                    transaction: t,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecurringDetailPage(recurringId: t.id),
                      ),
                    ),
                    onToggle: () => context.read<RecurringListBloc>().add(
                      ToggleRecurringStatus(t.id),
                    ),
                    onEdit: () {
                      final cat = CategoryModel(
                        key: t.categoryKey,
                        isIncome: t.type == TransactionType.income,
                        colorValue: 0xFF6200EA,
                        iconCode: Icons.category.codePoint,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      RecurringTransactionBottomSheet.show(
                        context,
                        cat,
                        existingRecurring: t,
                      );
                    },
                    onDelete: () => showDialog(
                      context: context,
                      builder: (d) => AlertDialog(
                        title: Text(translate.deleteRecurringTitle),
                        content: Text(
                          '${translate.delete} "${t.categoryKey}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(d),
                            child: Text(translate.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<RecurringListBloc>().add(
                                DeleteRecurring(t.id),
                              );
                              Navigator.pop(d);
                            },
                            child: Text(
                              translate.delete,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: state.filtered.length),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }
}

// ─── Filter delegate ───────────────────────────────────────────
class _RecurringFilterDelegate extends SliverPersistentHeaderDelegate {
  final RecurringFilterType currentFilter;
  final ValueChanged<RecurringFilterType> onFilterChanged;
  final bool isDark;
  _RecurringFilterDelegate({
    required this.currentFilter,
    required this.onFilterChanged,
    required this.isDark,
  });
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
        child: RecurringFilterChips(
          currentFilter: currentFilter,
          onFilterChanged: onFilterChanged,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_RecurringFilterDelegate old) =>
      old.currentFilter != currentFilter || old.isDark != isDark;
}

// ─── SliverAppBar ──────────────────────────────────────────────
class _RecurringSliverAppBar extends StatelessWidget {
  final RecurringListLoaded state;
  final bool isDark;
  final TextEditingController searchController;
  const _RecurringSliverAppBar({
    required this.state,
    required this.isDark,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;
    const expandedHeight = 260.0;

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
                      state: state,
                      primary: primary,
                      topPad: topPad,
                      searchController: searchController,
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

// ─── Expanded header ───────────────────────────────────────────
class _ExpandedHeader extends StatelessWidget {
  final RecurringListLoaded state;
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
    final activeCount = state.all.where((t) => t.isActive).length;
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
                            context.read<RecurringListBloc>().add(
                              RecurringSearchClosed(),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SearchField(
                            key: const ValueKey('exp_search'),
                            controller: searchController,
                            autofocus: true,
                            onChanged: (v) => context
                                .read<RecurringListBloc>()
                                .add(RecurringSearchChanged(v)),
                            onClose: () {
                              searchController.clear();
                              context.read<RecurringListBloc>().add(
                                RecurringSearchClosed(),
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
                                t.recurring,
                                style: AppTextStyles.h2.copyWith(
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '$activeCount ${t.active} · ${state.all.length} ${t.total}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 10.0),
                        ),
                        _IconBtn(
                          icon: Icons.search_rounded,
                          onTap: () => context.read<RecurringListBloc>().add(
                            RecurringSearchOpened(),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _RecurringStatsInline(state: state),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Collapsed header ──────────────────────────────────────────
class _CollapsedHeader extends StatelessWidget {
  final RecurringListLoaded state;
  final Color primary;
  final double topPad;
  final TextEditingController searchController;
  const _CollapsedHeader({
    required this.state,
    required this.primary,
    required this.topPad,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      color: primary,
      padding: EdgeInsets.only(top: topPad),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: state.searchOpen
            ? Padding(
                key: const ValueKey('col_search'),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: () {
                        searchController.clear();
                        context.read<RecurringListBloc>().add(
                          RecurringSearchClosed(),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SearchField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: (v) => context.read<RecurringListBloc>().add(
                          RecurringSearchChanged(v),
                        ),
                        onClose: () {
                          searchController.clear();
                          context.read<RecurringListBloc>().add(
                            RecurringSearchClosed(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              )
            : Padding(
                key: const ValueKey('col_title'),
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        t.recurring,
                        style: AppTextStyles.h5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ).paddingOnly(left: 10.0),
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
                        '${state.filtered.length}',
                        style: AppTextStyles.overline.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _IconBtn(
                      icon: Icons.search_rounded,
                      onTap: () => context.read<RecurringListBloc>().add(
                        RecurringSearchOpened(),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─── Search field ──────────────────────────────────────────────
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
    final t = AppLocalizations.of(context)!;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => TextField(
          controller: controller,
          autofocus: autofocus,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: t.searchByCategory,
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
        ),
      ),
    );
  }
}

// ─── Search banner ─────────────────────────────────────────────
class _SearchBanner extends StatelessWidget {
  final RecurringListLoaded state;
  const _SearchBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 13, color: primary),
          const SizedBox(width: 5),
          Text(
            '"${state.searchQuery}" · ${state.filtered.length}  result${state.filtered.length == 1 ? '' : 's'}',
            style: AppTextStyles.labelSmall.copyWith(color: primary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                context.read<RecurringListBloc>().add(RecurringSearchClosed()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primary.withValues(alpha: 0.25)),
              ),
              child: Text(
                t.clear,
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

// ─── Stats card ────────────────────────────────────────────────
class _RecurringStatsInline extends StatelessWidget {
  final RecurringListLoaded state;
  const _RecurringStatsInline({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final stats = state.stats;
    final activeCount = state.all.where((t) => t.isActive).length;
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
                    t.monthlyNet,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(stats.netMonthly.abs(), decimalDigits: 0),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$activeCount ${t.active}',
                  style: AppTextStyles.overline.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Pill(
                label: t.income,
                value: '${CurrencyFormatter.format(stats.monthlyIncomeEstimate, decimalDigits: 0)}/mo',
                icon: Icons.arrow_downward_rounded,
              ),
              const SizedBox(width: 10),
              _Pill(
                label: t.expense,
                value:
                    '${CurrencyFormatter.format(stats.monthlyExpenseEstimate, decimalDigits: 0)}/mo',
                icon: Icons.arrow_upward_rounded,
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

// ─── Empty search/filter result ────────────────────────────────
class _EmptyFilterView extends StatelessWidget {
  const _EmptyFilterView();
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
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
              Icons.search_off_rounded,
              size: 38,
              color: primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            t.noResultsFound,
            style: AppTextStyles.h5.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.tryDifferentFilter,
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Icon button ───────────────────────────────────────────────
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
