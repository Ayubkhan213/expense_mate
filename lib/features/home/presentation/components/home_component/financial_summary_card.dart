import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancialSummaryCard extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double totalDebtOwed;
  final double totalDebtLent;

  const FinancialSummaryCard({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalDebtOwed,
    required this.totalDebtLent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
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
            offset: Offset(0, 10),
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
              Text(
                'Total Balance',
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  shadows: isDark
                      ? null
                      : [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: isDark ? colorScheme.primary : Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      DateFormat('MMMM yyyy').format(DateTime.now()),
                      style: TextStyle(
                        color: isDark ? colorScheme.primary : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Main Balance
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              shadows: isDark
                  ? null
                  : [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
            ),
          ),
          SizedBox(height: 10),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Income',
                  amount: totalIncome,
                  icon: Icons.arrow_downward,
                  color: Color(0xFF10b981),
                  isPositive: true,
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatItem(
                  label: 'Expense',
                  amount: totalExpense,
                  icon: Icons.arrow_upward,
                  color: Color(0xFFef4444),
                  isPositive: false,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'You Owe',
                  amount: totalDebtOwed,
                  icon: Icons.trending_down,
                  color: Color(0xFFef4444),
                  isPositive: false,
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatItem(
                  label: "You're Owed",
                  amount: totalDebtLent,
                  icon: Icons.trending_up,
                  color: Color(0xFF10b981),
                  isPositive: true,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isPositive;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.isPositive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? color.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.95),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    shadows: isDark
                        ? null
                        : [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${isPositive ? '+' : '-'}\$${_formatAmount(amount)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              shadows: [
                Shadow(
                  color: isDark
                      ? color.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.2),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return NumberFormat('#,##0').format(amount.abs());
    }
    return NumberFormat('#,##0.00').format(amount.abs());
  }
}
