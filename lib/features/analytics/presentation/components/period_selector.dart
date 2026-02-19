import 'package:flutter/material.dart';
import '../bloc/analytics_event.dart';

class PeriodSelector extends StatelessWidget {
  final AnalyticsPeriod currentPeriod;
  final Function(AnalyticsPeriod) onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.currentPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildPeriodChip(context, AnalyticsPeriod.week, 'Week'),
            const SizedBox(width: 8),
            _buildPeriodChip(context, AnalyticsPeriod.month, 'Month'),
            const SizedBox(width: 8),
            _buildPeriodChip(context, AnalyticsPeriod.threeMonths, '3 Months'),
            const SizedBox(width: 8),
            _buildPeriodChip(context, AnalyticsPeriod.sixMonths, '6 Months'),
            const SizedBox(width: 8),
            _buildPeriodChip(context, AnalyticsPeriod.year, 'Year'),
            const SizedBox(width: 8),
            _buildPeriodChip(context, AnalyticsPeriod.all, 'All Time'),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(
    BuildContext context,
    AnalyticsPeriod period,
    String label,
  ) {
    final isSelected = currentPeriod == period;
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPeriodChanged(period),
      backgroundColor: theme.cardColor,
      selectedColor: theme.primaryColor.withOpacity(0.2),
      checkmarkColor: theme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.primaryColor
            : theme.textTheme.bodyMedium?.color,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
