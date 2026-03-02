import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RecurringDetailMonthlyEstimate extends StatelessWidget {
  final double monthlyAmount;
  final bool isIncome;

  const RecurringDetailMonthlyEstimate({
    super.key,
    required this.monthlyAmount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  t.monthlyEstimate,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${isIncome ? '+' : '-'}${monthlyAmount.toStringAsFixed(2)}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              t.perMonth,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
