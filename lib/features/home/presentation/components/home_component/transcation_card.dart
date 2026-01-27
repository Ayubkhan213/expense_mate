import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction; // Replace with TransactionModel

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isIncome = transaction.type.toString().contains('income');
    final color = isIncome ? Color(0xFF10b981) : Color(0xFFef4444);
    final icon = _getIcon();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: transaction.isDebt
            ? Border.all(
                color: colorScheme.secondary.withValues(alpha: 0.4),
                width: 1,
              )
            : Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(icon, style: TextStyle(fontSize: 24))),
          ),
          SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction.items.first.category.capitalizeFirst(),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (transaction.isDebt)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'DEBT',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  '${DateFormat('MMM dd, yyyy').format(transaction.date)} • ${transaction.paymentMethod.name}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${isIncome ? '+' : '-'}\$${transaction.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getIcon() {
    final category = transaction.items.first.category.toLowerCase();
    if (category.contains('food') || category.contains('restaurant')) {
      return '🍔';
    }
    if (category.contains('salary')) return '💰';
    if (category.contains('transport')) return '🚗';
    if (category.contains('shopping')) return '🛒';
    return '💵';
  }
}
