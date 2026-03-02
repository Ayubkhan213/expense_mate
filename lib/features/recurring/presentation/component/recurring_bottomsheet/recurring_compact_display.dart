import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_state.dart';

/// Compact display showing category icon, name and amount
class RecurringCompactDisplay extends StatelessWidget {
  final CategoryHiveModel category;
  final AddEditRecurringState state;

  const RecurringCompactDisplay({
    super.key,
    required this.category,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = category.isIncome;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          _buildCategoryInfo(theme, isIncome, context),
          _buildAmount(theme),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(category.colorValue).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        IconData(category.iconCode, fontFamily: 'MaterialIcons'),
        color: Color(category.colorValue),
        size: 20,
      ),
    );
  }

  Widget _buildCategoryInfo(
    ThemeData theme,
    bool isIncome,
    BuildContext context,
  ) {
    final t = AppLocalizations.of(context)!;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(category.key),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${t.recurring} ${isIncome ? t.income : t.expense}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isIncome ? Colors.green : Colors.red,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmount(ThemeData theme) {
    return Text(
      state.amount.isEmpty ? '0' : state.amount,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
      ),
    );
  }
}
