import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtSummaryCard extends StatelessWidget {
  final String debtName;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;

  const DebtSummaryCard({
    super.key,
    required this.debtName,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final progress = totalAmount > 0 ? (paidAmount / totalAmount) : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  colorScheme.surface,
                  colorScheme.surface.withValues(alpha: 0.9),
                ]
              : [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.90),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.secondary.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  debtName.toUpperCase(),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    shadows: isDark
                        ? null
                        : [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? colorScheme.primary.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(1)}% Paid',
                  style: TextStyle(
                    color: isDark ? colorScheme.primary : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Amount Grid
          Row(
            children: [
              Expanded(
                child: _AmountBox(
                  label: 'Total Debt',
                  amount: totalAmount,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.9),
                  isDark: isDark,
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AmountBox(
                  label: 'Paid',
                  amount: paidAmount,
                  color: const Color(0xFF10b981),
                  isDark: isDark,
                  isPrimary: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Remaining Amount (Featured)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFef4444).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_formatAmount(remainingAmount)}',
                      style: TextStyle(
                        color: const Color(0xFFef4444),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: const Color(
                              0xFFef4444,
                            ).withValues(alpha: 0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFef4444).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_down,
                    color: Color(0xFFef4444),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF10b981),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }
}

class _AmountBox extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isDark;
  final bool isPrimary;

  const _AmountBox({
    required this.label,
    required this.amount,
    required this.color,
    required this.isDark,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${_formatAmount(amount)}',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return NumberFormat('#,##0').format(amount);
    }
    return NumberFormat('#,##0.00').format(amount);
  }
}
