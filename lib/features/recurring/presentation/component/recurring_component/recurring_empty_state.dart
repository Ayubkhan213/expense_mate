import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Empty state when no recurring transactions exist
class RecurringEmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const RecurringEmptyState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.repeat, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            t.noRecurringTransactions,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            t.setUpAutomatic,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add),
            label: Text(t.addFirstRecurring),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
