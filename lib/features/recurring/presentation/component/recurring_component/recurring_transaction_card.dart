import 'package:spendio/core/data/models/recurring_transcation_sql_model.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/utils/translation_helper.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:spendio/core/data/models/enums.dart';

/// Recurring Transaction Card Component
/// Displays individual recurring transaction with actions
class RecurringTransactionCard extends StatelessWidget {
  final RecurringTransactionModel transaction;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecurringTransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    final isIncome = transaction.type == TransactionType.income;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme, isIncome, t, context),
              const SizedBox(height: 12),
              _buildNextOccurrence(theme, t),
              const SizedBox(height: 12),
              _buildActionButtons(t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    bool isIncome,
    AppLocalizations t,
    BuildContext context,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(transaction.categoryKey),
                // transaction.categoryKey.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getFrequencyText(transaction.frequency, t),
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            _buildStatusBadge(t),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: transaction.isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        transaction.isActive ? t.active : t.inactive,
        style: TextStyle(
          color: transaction.isActive ? Colors.green : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNextOccurrence(ThemeData theme, AppLocalizations t) {
    return Row(
      children: [
        const Icon(Icons.event, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          '${t.next}: ${_formatDate(transaction.nextOccurrence)}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const Spacer(),
        if (transaction.isDue) _buildDueBadge(t),
      ],
    );
  }

  Widget _buildDueBadge(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber, size: 14, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            t.dueNow,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations t) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onToggle,
            icon: Icon(
              transaction.isActive ? Icons.pause : Icons.play_arrow,
              size: 16,
            ),
            label: Text(transaction.isActive ? t.pause : t.resume),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit, // ADD THIS CALLBACK
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: Text(t.edit),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 16),
            label: Text(t.delete),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  String _getFrequencyText(RecurrenceFrequency frequency, AppLocalizations t) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return t.daily;
      case RecurrenceFrequency.weekly:
        return t.weekly;
      case RecurrenceFrequency.biweekly:
        return t.biweekly;
      case RecurrenceFrequency.monthly:
        return t.monthly;
      case RecurrenceFrequency.quarterly:
        return t.quarterly;
      case RecurrenceFrequency.yearly:
        return t.yearly;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
