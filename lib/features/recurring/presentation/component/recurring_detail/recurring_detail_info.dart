import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:flutter/material.dart';

class RecurringDetailInfo extends StatelessWidget {
  final RecurringTransactionModel transaction;

  const RecurringDetailInfo({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.repeat,
              label: 'Frequency',
              value: _getFrequencyText(transaction.frequency),
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.payment,
              label: 'Payment Method',
              value: _getPaymentMethodText(transaction.paymentMethod),
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Start Date',
              value: _formatDate(transaction.startDate),
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.event,
              label: 'End Date',
              value: transaction.endDate != null
                  ? _formatDate(transaction.endDate!)
                  : 'Never',
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.schedule,
              label: 'Next Occurrence',
              value: _formatDate(transaction.nextOccurrence),
              valueColor: transaction.isDue ? Colors.orange : null,
            ),
            if (transaction.frequency == RecurrenceFrequency.monthly ||
                transaction.frequency == RecurrenceFrequency.quarterly ||
                transaction.frequency == RecurrenceFrequency.yearly) ...[
              const Divider(),
              _DetailRow(
                icon: Icons.today,
                label: 'Day of Month',
                value: transaction.dayOfMonth.toString(),
              ),
            ],
            if (transaction.note != null) ...[
              const Divider(),
              _DetailRow(
                icon: Icons.note,
                label: 'Note',
                value: transaction.note!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getFrequencyText(RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.biweekly:
        return 'Bi-weekly';
      case RecurrenceFrequency.monthly:
        return 'Monthly';
      case RecurrenceFrequency.quarterly:
        return 'Quarterly';
      case RecurrenceFrequency.yearly:
        return 'Yearly';
    }
  }

  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.bank:
        return 'Bank';
      case PaymentMethod.wallet:
        return 'Wallet';
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
