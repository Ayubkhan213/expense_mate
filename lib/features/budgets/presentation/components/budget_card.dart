// ============================================
// IMPROVED BUDGET CARD WIDGET
// ============================================

import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:intl/intl.dart';

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback onTap;

  const BudgetCard({required this.budget, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = Color(budget.colorCode ?? theme.colorScheme.primary.value);
    final icon = budget.icon != null
        ? IconData(int.parse(budget.icon!), fontFamily: 'MaterialIcons')
        : Icons.account_balance_wallet;

    final isOverBudget = budget.isOverBudget;
    final percentage = budget.spentPercentage;
    final remaining = budget.remainingAmount;
    final daysLeft = budget.daysRemaining;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.1),
                    color.withValues(alpha: 0.05),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isOverBudget
                ? theme.colorScheme.error.withValues(alpha: 0.5)
                : color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      SizedBox(width: 16),

                      // Budget Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    budget.name,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Type Badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    budget.type.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '${DateFormat('MMM dd').format(budget.startDate)} - ${DateFormat('MMM dd, yyyy').format(budget.endDate)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Amount Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spent',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$${budget.spentAmount.toStringAsFixed(0)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isOverBudget
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isOverBudget ? 'Over by' : 'Remaining',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$${remaining.abs().toStringAsFixed(0)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isOverBudget
                                  ? theme.colorScheme.error
                                  : color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Progress Bar
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (percentage / 100).clamp(0.0, 1.0),
                          minHeight: 12,
                          backgroundColor: theme.colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation(
                            isOverBudget ? theme.colorScheme.error : color,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${percentage.toStringAsFixed(1)}% used',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isOverBudget
                                  ? theme.colorScheme.error
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (daysLeft >= 0)
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 14,
                                  color: daysLeft <= 7
                                      ? Colors.orange
                                      : theme.colorScheme.onSurface.withOpacity(
                                          0.6,
                                        ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '$daysLeft days left',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: daysLeft <= 7
                                        ? Colors.orange
                                        : theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                    fontWeight: daysLeft <= 7
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Expired ${(-daysLeft)} days ago',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '${budget.transactionIds.length} transactions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      print(1111111);
                      Navigator.pushNamed(context, RouteName.budgetDetails);
                    },
                    child: Row(
                      children: [
                        Text(
                          'View Details',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12, color: color),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
