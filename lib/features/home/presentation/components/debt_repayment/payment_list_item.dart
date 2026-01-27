import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:expense_mate/core/data/models/debt_payment_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';

class PaymentListItem extends StatelessWidget {
  final dynamic payment; // Replace with DebtPaymentModel
  final VoidCallback? onDelete;

  const PaymentListItem({super.key, required this.payment, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final dateFormat = DateFormat('MMM dd, yyyy');
    final amount = payment.amount ?? 0.0;
    final paymentDate = payment.paymentDate ?? DateTime.now();
    final note = payment.note;
    final paymentMethod = payment.paymentMethod;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF10b981).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF10b981).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Icon(
            _getPaymentMethodIcon(paymentMethod),
            color: const Color(0xFF10b981),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              '\$${_formatAmount(amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10b981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF10b981).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _getMethodName(paymentMethod),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10b981),
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 6),
                Text(
                  dateFormat.format(paymentDate),
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            if (note != null && note.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.background : colorScheme.surface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  note,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                color: const Color(0xFFef4444),
                onPressed: () => _showDeleteConfirmation(context),
                tooltip: 'Delete payment',
              )
            : null,
      ),
    );
  }

  IconData _getPaymentMethodIcon(dynamic method) {
    final methodStr = method.toString().toLowerCase();
    if (methodStr.contains('cash')) return Icons.money;
    if (methodStr.contains('card')) return Icons.credit_card;
    if (methodStr.contains('bank')) return Icons.account_balance;
    if (methodStr.contains('wallet')) return Icons.wallet;
    return Icons.payment;
  }

  String _getMethodName(dynamic method) {
    final methodStr = method.toString().split('.').last;
    return methodStr[0].toUpperCase() + methodStr.substring(1);
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Delete Payment'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this payment? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFef4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
