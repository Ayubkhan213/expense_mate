import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RecurringGeneratedTransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const RecurringGeneratedTransactionsList({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    if (transactions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                t.noTransactionsYet,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${t.generatedTransactions}  (${transactions.length})',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.receipt,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  _formatDate(transaction.date),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _getPaymentMethodText(transaction.paymentMethod, t),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                trailing: Text(
                  transaction.totalAmount.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.primaryColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
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

  // String _getPaymentMethodText(paymentMethod) {
  //   return paymentMethod.toString().split('.').last.toUpperCase();
  // }
}
