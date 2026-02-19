import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';

import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_state.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_component/recurring_transaction_card.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_component/recurring_empty_state.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_component/recurring_starts_card.dart';
import 'package:expense_mate/features/recurring/presentation/faces/recurring_bottomsheet.dart';
import 'package:expense_mate/features/recurring/presentation/faces/recurring_category_selection.dart';
import 'package:expense_mate/features/recurring/presentation/faces/recurring_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/recurring_component/recurring_filter_chips.dart';

/// Main recurring transactions list screen
class RecurringFace extends StatelessWidget {
  const RecurringFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<RecurringListBloc, RecurringListState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is RecurringListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecurringListLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RecurringListBloc>().add(LoadRecurringList());
              },
              child: _buildContent(context, state),
            );
          }

          if (state is RecurringListError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Recurring Transactions'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<RecurringListBloc>().add(ProcessDueRecurring());
          },
          tooltip: 'Process Due Transactions',
        ),
        _buildFilterMenu(context),
      ],
    );
  }

  Widget _buildFilterMenu(BuildContext context) {
    return PopupMenuButton<RecurringFilterType>(
      icon: const Icon(Icons.filter_list),
      onSelected: (filter) {
        context.read<RecurringListBloc>().add(FilterRecurringList(filter));
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: RecurringFilterType.all, child: Text('All')),
        const PopupMenuItem(
          value: RecurringFilterType.active,
          child: Text('Active'),
        ),
        const PopupMenuItem(
          value: RecurringFilterType.inactive,
          child: Text('Inactive'),
        ),
        const PopupMenuItem(
          value: RecurringFilterType.income,
          child: Text('Income Only'),
        ),
        const PopupMenuItem(
          value: RecurringFilterType.expense,
          child: Text('Expense Only'),
        ),
        const PopupMenuItem(
          value: RecurringFilterType.dueSoon,
          child: Text('Due Soon'),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, RecurringListLoaded state) {
    if (state.all.isEmpty) {
      return RecurringEmptyState(
        onAddPressed: () => _showAddRecurring(context),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: RecurringStatsCard(stats: state.stats)),
        SliverToBoxAdapter(
          child: RecurringFilterChips(
            currentFilter: state.currentFilter,
            onFilterChanged: (filter) {
              context.read<RecurringListBloc>().add(
                FilterRecurringList(filter),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final transaction = state.filtered[index];
              return RecurringTransactionCard(
                transaction: transaction,
                onTap: () => _navigateToDetail(context, transaction),
                onToggle: () {
                  context.read<RecurringListBloc>().add(
                    ToggleRecurringStatus(transaction.id),
                  );
                },
                onEdit: () =>
                    _showEditRecurring(context, transaction), // ADD THIS
                onDelete: () => _showDeleteDialog(context, transaction),
              );
            }, childCount: state.filtered.length),
          ),
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, RecurringListState state) {
    if (state is RecurringListError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    } else if (state is RecurringListOperationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.green),
      );
    }
  }

  void _showAddRecurring(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecurringCategorySelector()),
    );
  }

  void _navigateToDetail(
    BuildContext context,
    RecurringTransactionModel transaction,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecurringDetailPage(recurringId: transaction.id),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    RecurringTransactionModel transaction,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Recurring Transaction'),
        content: Text(
          'Are you sure you want to delete "${transaction.categoryKey}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<RecurringListBloc>().add(
                DeleteRecurring(transaction.id),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditRecurring(
    BuildContext context,
    RecurringTransactionModel transaction,
  ) {
    // Create a minimal category object from transaction data
    final category = CategoryHiveModel(
      key: transaction.categoryKey,
      isIncome: transaction.type == TransactionType.income,
      colorValue: 0xFF6200EA, // Default color
      iconCode: Icons.category.codePoint, // Default icon
    );

    RecurringTransactionBottomSheet.show(
      context,
      category,
      existingRecurring: transaction,
    );
  }
}
