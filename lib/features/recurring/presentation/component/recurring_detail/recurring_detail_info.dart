import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RecurringDetailInfo extends StatelessWidget {
  final RecurringTransactionModel transaction;

  const RecurringDetailInfo({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.details,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.repeat,
              label: t.frequency,
              value: _getFrequencyText(transaction.frequency, t),
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.payment,
              label: t.paymentMethod,
              value: _getPaymentMethodText(transaction.paymentMethod, t),
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.calendar_today,
              label: t.startDate,
              value: _formatDate(transaction.startDate),
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.event,
              label: t.endDate,
              value: transaction.endDate != null
                  ? _formatDate(transaction.endDate!)
                  : t.never,
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.schedule,
              label: t.nextOccurrence,
              value: _formatDate(transaction.nextOccurrence),
              valueColor: transaction.isDue ? Colors.orange : null,
            ),
            if (transaction.frequency == RecurrenceFrequency.monthly ||
                transaction.frequency == RecurrenceFrequency.quarterly ||
                transaction.frequency == RecurrenceFrequency.yearly) ...[
              const Divider(),
              _DetailRow(
                icon: Icons.today,
                label: t.dayOfMonth,
                value: transaction.dayOfMonth.toString(),
              ),
            ],
            if (transaction.note != null) ...[
              const Divider(),
              _DetailRow(
                icon: Icons.note,
                label: t.note,
                value: transaction.note!,
              ),
            ],
          ],
        ),
      ),
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

  String _getPaymentMethodText(PaymentMethod method, AppLocalizations t) {
    switch (method) {
      case PaymentMethod.cash:
        return t.cash;
      case PaymentMethod.card:
        return t.card;
      case PaymentMethod.bank:
        return t.bank;
      case PaymentMethod.wallet:
        return t.wallet;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
