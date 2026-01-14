import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_state.dart';
import 'package:expense_mate/features/budgets/presentation/components/budget_card.dart';
import 'package:expense_mate/features/budgets/presentation/faces/budget_details.dart';

import 'package:expense_mate/core/data/models/budget_model.dart';

class BudgetsFace extends StatefulWidget {
  const BudgetsFace({super.key});

  @override
  State<BudgetsFace> createState() => _BudgetsFaceState();
}

class _BudgetsFaceState extends State<BudgetsFace> {
  BudgetFilter _selectedFilter = BudgetFilter.active;

  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(LoadBudgetsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.95),
                ]
              : [
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                  theme.colorScheme.surface,
                ],
        ),
      ),
      child: Column(
        children: [
          // Header Section
          _buildHeader(theme, isDark),

          // Filter Chips
          _buildFilterChips(theme, isDark),

          // Budget List
          Expanded(
            child: BlocBuilder<BudgetBloc, BudgetState>(
              builder: (context, state) {
                if (state.status == BudgetStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  );
                }

                if (state.status == BudgetStatus.error) {
                  return _buildErrorState(theme, state.errorMessage);
                }

                final budgets = _getFilteredBudgets(state);

                if (budgets.isEmpty) {
                  return _buildEmptyState(theme, isDark);
                }

                return _buildBudgetList(budgets, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        final activeBudgets = state.activeBudgets;

        return Container(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.secondary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budgets',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${activeBudgets.length} active budgets',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search),
                        color: theme.colorScheme.primary,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          // TODO: Show menu
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips(ThemeData theme, bool isDark) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChoiceChip(
                  label: 'Active (${state.activeBudgets.length})',
                  icon: Icons.trending_up,
                  filter: BudgetFilter.active,
                  theme: theme,
                  isDark: isDark,
                ),
                SizedBox(width: 12),
                _buildChoiceChip(
                  label:
                      'Expired (${state.budgets.where((b) => b.isExpired).length})',
                  icon: Icons.event_busy,
                  filter: BudgetFilter.expired,
                  theme: theme,
                  isDark: isDark,
                ),
                SizedBox(width: 12),
                _buildChoiceChip(
                  label: 'Archived (${state.archivedBudgets.length})',
                  icon: Icons.archive,
                  filter: BudgetFilter.archived,
                  theme: theme,
                  isDark: isDark,
                ),
                SizedBox(width: 12),
                _buildChoiceChip(
                  label: 'All (${state.budgets.length})',
                  icon: Icons.list,
                  filter: BudgetFilter.all,
                  theme: theme,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required IconData icon,
    required BudgetFilter filter,
    required ThemeData theme,
    required bool isDark,
  }) {
    final isSelected = _selectedFilter == filter;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
          ),
          SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
      },
      backgroundColor: isDark
          ? theme.colorScheme.surface
          : theme.colorScheme.primary.withValues(alpha: 0.05),
      selectedColor: theme.colorScheme.primary,
      checkmarkColor: theme.colorScheme.onPrimary,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
      ),
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
    );
  }

  List<BudgetModel> _getFilteredBudgets(BudgetState state) {
    switch (_selectedFilter) {
      case BudgetFilter.active:
        return state.activeBudgets;
      case BudgetFilter.expired:
        return state.budgets
            .where((b) => b.isExpired && !b.isArchived)
            .toList();
      case BudgetFilter.archived:
        return state.archivedBudgets;
      case BudgetFilter.all:
        return state.budgets;
    }
  }

  Widget _buildBudgetList(List<BudgetModel> budgets, ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        return BudgetCard(
          budget: budgets[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BudgetDetailsFace(budget: budgets[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    String message;
    IconData icon;

    switch (_selectedFilter) {
      case BudgetFilter.active:
        message = 'No active budgets yet.\nCreate one to start tracking!';
        icon = Icons.add_card;
        break;
      case BudgetFilter.expired:
        message = 'No expired budgets';
        icon = Icons.event_busy;
        break;
      case BudgetFilter.archived:
        message = 'No archived budgets';
        icon = Icons.archive;
        break;
      case BudgetFilter.all:
        message = 'No budgets yet.\nCreate your first budget!';
        icon = Icons.account_balance_wallet;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          SizedBox(height: 16),
          Text(
            errorMessage ?? 'Something went wrong',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<BudgetBloc>().add(LoadBudgetsEvent());
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}

enum BudgetFilter { active, expired, archived, all }
