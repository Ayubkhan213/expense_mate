import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/navigation/route_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtCard extends StatelessWidget {
  final DebtModel debt; // Replace with DebtModel

  const DebtCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Assuming debt has these properties
    final debtType = debt.debtType; // DebtType.borrowed or DebtType.lent
    final color = debtType.toString().contains('borrowed')
        ? Color(0xFFef4444)
        : Color(0xFF10b981);
    final isOverdue = debt.isOverdue ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue
              ? Colors.red.withValues(alpha: 0.5)
              : color.withValues(alpha: 0.3),
          width: isOverdue ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  debtType.toString().contains('borrowed')
                      ? Icons.trending_down
                      : Icons.trending_up,
                  color: color,
                ),
              ),
              SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      debtType.toString().contains('borrowed')
                          ? 'Borrowed from ${debt.personName}'
                          : 'Lent to ${debt.personName}',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '\$${debt.remainingAmount.toStringAsFixed(2)} remaining',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Action
              IconButton(
                icon: Icon(Icons.add_circle, color: colorScheme.secondary),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteName.debtRepayment,
                    arguments: {'debt': debt},
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: debt.paymentPercentage / 100,
              minHeight: 6,
              backgroundColor: isDark
                  ? colorScheme.surface.withValues(alpha: 0.3)
                  : Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          SizedBox(height: 8),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${debt.paymentPercentage.toStringAsFixed(0)}% paid',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isOverdue)
                Text(
                  '⚠️ ${debt.daysOverdue} days overdue',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Text(
                  'Due: ${DateFormat('MMM dd').format(debt.expectedReturnDate)}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
