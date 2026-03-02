import 'package:expense_mate/core/data/models/analytics_data_models.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BudgetOverviewCard extends StatelessWidget {
  final BudgetAnalysis budgetAnalysis;

  const BudgetOverviewCard({super.key, required this.budgetAnalysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    if (budgetAnalysis.totalBudgets == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.budgetOverview,
                  style: AppTextStyles.h4.copyWith(
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${budgetAnalysis.activeBudgets} ${t.active}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Overall Budget Utilization
            _buildOverallUtilization(theme, t),

            const SizedBox(height: 20),

            // Budget Statistics
            _buildBudgetStats(theme, t),

            if (budgetAnalysis.budgetProgresses.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Individual Budget Progress
              ...budgetAnalysis.budgetProgresses.map(
                (progress) => _buildBudgetProgressItem(progress, theme, t),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverallUtilization(ThemeData theme, AppLocalizations t) {
    final utilization = budgetAnalysis.overallBudgetUtilization;
    final isOverBudget = utilization > 100;
    final progressColor = isOverBudget
        ? Colors.red
        : utilization > 80
        ? Colors.orange
        : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t.overallUtilization, style: AppTextStyles.subtitle2),
            Text(
              '${utilization.toStringAsFixed(1)}%',
              style: AppTextStyles.subtitle1.copyWith(
                color: progressColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (utilization / 100).clamp(0, 1),
            minHeight: 12,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${budgetAnalysis.totalSpentAmount.toStringAsFixed(0)} ${t.spent}',
              style: AppTextStyles.caption.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
            Text(
              '${t.ofa} \$${budgetAnalysis.totalBudgetAmount.toStringAsFixed(0)}',
              style: AppTextStyles.caption.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetStats(ThemeData theme, AppLocalizations t) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            t.totalBudget,
            budgetAnalysis.totalBudgets.toString(),
            Icons.account_balance_wallet,
            theme.primaryColor,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            t.overBudget,
            budgetAnalysis.overBudgetCount.toString(),
            Icons.warning_amber_rounded,
            budgetAnalysis.overBudgetCount > 0 ? Colors.red : Colors.grey,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h3.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetProgressItem(
    BudgetProgress progress,
    ThemeData theme,
    AppLocalizations t,
  ) {
    final progressColor = progress.isOverBudget
        ? Colors.red
        : progress.percentage > 80
        ? Colors.orange
        : Colors.green;

    final budgetColor = progress.colorCode != null
        ? Color(progress.colorCode!)
        : theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  progress.budgetName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: budgetColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${progress.percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (progress.percentage / 100).clamp(0, 1),
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${progress.spentAmount.toStringAsFixed(0)} ${t.ofa} \$${progress.budgetAmount.toStringAsFixed(0)}',
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
