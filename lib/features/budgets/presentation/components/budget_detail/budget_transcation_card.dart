import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetTransactionCard extends StatelessWidget {
  final dynamic transaction;
  final VoidCallback? onTap;

  const BudgetTransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    final firstItem = transaction.items?.isNotEmpty == true
        ? transaction.items.first
        : null;
    final isExpense = transaction.type.toString().contains('expense');
    final amount = transaction.totalAmount ?? 0.0;
    final date = transaction.date ?? DateTime.now();
    final paymentMethod = transaction.paymentMethod;
    final itemCount = transaction.items?.length ?? 0;

    // ✅ translate category
    final categoryLabel = firstItem?.category != null
        ? context.tr(firstItem!.category.toString())
        : t.transaction;

    // ✅ translate payment method
    final methodLabel = context.trMethod(
      paymentMethod.toString().split('.').last,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.1),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isExpense
                        ? const Color(0xFFef4444).withValues(alpha: 0.15)
                        : const Color(0xFF10b981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isExpense
                          ? const Color(0xFFef4444).withValues(alpha: 0.3)
                          : const Color(0xFF10b981).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getPaymentIcon(paymentMethod),
                    color: isExpense
                        ? const Color(0xFFef4444)
                        : const Color(0xFF10b981),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryLabel, // ✅ translated
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd').format(date),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              methodLabel, // ✅ translated
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isExpense ? '-' : '+'}\$${_formatAmount(amount)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isExpense
                            ? const Color(0xFFef4444)
                            : const Color(0xFF10b981),
                      ),
                    ),
                    if (itemCount > 1) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${itemCount - 1} ${t.more}', // ✅ translated
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(dynamic method) {
    final methodStr = method.toString().toLowerCase();
    if (methodStr.contains('cash')) return Icons.money;
    if (methodStr.contains('card')) return Icons.credit_card;
    if (methodStr.contains('bank')) return Icons.account_balance;
    if (methodStr.contains('wallet')) return Icons.wallet;
    return Icons.receipt;
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(2);
  }
}
