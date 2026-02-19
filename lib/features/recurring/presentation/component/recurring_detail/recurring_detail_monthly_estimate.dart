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
                  'Monthly Estimate',
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
              'per month',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
