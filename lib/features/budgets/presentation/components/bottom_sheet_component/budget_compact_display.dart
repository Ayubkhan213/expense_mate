import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/core/theme/typography/text_style_extension.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BudgetCompactDisplay extends StatelessWidget {
  final BudgetFormState state;

  const BudgetCompactDisplay({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final amount = state.amount.isNotEmpty ? state.amount : '0';
    final name = state.name.isNotEmpty ? state.name : t.newBudget;
    final color = state.selectedColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(state.selectedIcon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.cardTitle.withColor(color).semiBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _typeLabel(state.selectedType, t),
                  style: AppTextStyles.captionSmall.withColor(color).medium,
                ),
              ],
            ),
          ),

          Text(
            '\$$amount',
            style: AppTextStyles.currencyMedium.withColor(color),
          ),
        ],
      ),
    );
  }

  // Replace _typeLabel method with:
  String _typeLabel(dynamic type, AppLocalizations t) {
    final s = type.toString().toLowerCase();
    if (s.contains('monthly')) return t.monthlyBudget;
    if (s.contains('project')) return t.projectBudget;
    return t.customBudget;
  }
}
