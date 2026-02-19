import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_state.dart';
import 'package:flutter/material.dart';

/// Horizontal scrollable filter chips
class RecurringFilterChips extends StatelessWidget {
  final RecurringFilterType currentFilter;
  final Function(RecurringFilterType) onFilterChanged;

  const RecurringFilterChips({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip(context, 'All', RecurringFilterType.all),
          _buildChip(context, 'Active', RecurringFilterType.active),
          _buildChip(context, 'Inactive', RecurringFilterType.inactive),
          _buildChip(context, 'Income', RecurringFilterType.income),
          _buildChip(context, 'Expense', RecurringFilterType.expense),
          _buildChip(context, 'Due Soon', RecurringFilterType.dueSoon),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    RecurringFilterType type,
  ) {
    final theme = Theme.of(context);
    final isSelected = currentFilter == type;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onFilterChanged(type),
        selectedColor: theme.primaryColor,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : theme.primaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
