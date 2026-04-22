import 'package:spendio/core/data/models/analytics_data_models.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FinancialSummaryCard extends StatelessWidget {
  final FinancialSummary summary;

  const FinancialSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.financialOverview,
              style: AppTextStyles.h4.copyWith(
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 20),

            // Net Balance - Large Display
            _buildNetBalanceSection(theme, t),

            const SizedBox(height: 24),

            // Income and Expense Row
            Row(
              children: [
                Expanded(
                  child: _buildAmountCard(
                    t.income,
                    summary.totalIncome,
                    Colors.green,
                    Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAmountCard(
                    t.expense,
                    summary.totalExpense,
                    Colors.red,
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Statistics Grid
            _buildStatisticsGrid(theme, t),
          ],
        ),
      ),
    );
  }

  Widget _buildNetBalanceSection(ThemeData theme, AppLocalizations t) {
    final isPositive = summary.netBalance >= 0;
    final balanceColor = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: balanceColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.netBalance,
            style: AppTextStyles.subtitle2.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: balanceColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${isPositive ? '+' : ''}${CurrencyFormatter.format(summary.netBalance.abs())}',
                  style: AppTextStyles.currencyLarge.copyWith(
                    color: balanceColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(
    String label,
    double amount,
    Color color,
    IconData icon,
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
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(amount),
            style: AppTextStyles.currencySmall.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(ThemeData theme, AppLocalizations t) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                t.transactions,
                summary.totalTransactions.toString(),
                Icons.receipt_long,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                t.avgDaily,
                CurrencyFormatter.format(summary.averageDailyExpense, decimalDigits: 0),
                Icons.calendar_today,
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                t.avgTransaction,
                CurrencyFormatter.format(summary.averageTransactionAmount, decimalDigits: 0),
                Icons.payments,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                t.savingsRate,
                '${summary.savingsRate.toStringAsFixed(1)}%',
                Icons.savings,
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
