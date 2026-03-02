import 'package:expense_mate/core/data/models/analytics_data_models.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DebtOverviewCard extends StatelessWidget {
  final DebtAnalysis debtAnalysis;

  const DebtOverviewCard({super.key, required this.debtAnalysis});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasDebts =
        debtAnalysis.activeBorrowedCount > 0 ||
        debtAnalysis.activeLentCount > 0;

    if (!hasDebts) {
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
            Text(
              t.debtOverview,
              style: AppTextStyles.h4.copyWith(
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 20),

            // Borrowed Section
            if (debtAnalysis.activeBorrowedCount > 0) ...[
              _buildDebtSection(
                t.borrowed,
                debtAnalysis.totalBorrowed,
                debtAnalysis.borrowedRemaining,
                debtAnalysis.activeBorrowedCount,
                debtAnalysis.overdueBorrowedCount,
                Colors.red,
                Icons.arrow_downward,
                theme,
                t,
              ),
              const SizedBox(height: 16),
            ],

            // Lent Section
            if (debtAnalysis.activeLentCount > 0) ...[
              _buildDebtSection(
                t.lent,
                debtAnalysis.totalLent,
                debtAnalysis.lentRemaining,
                debtAnalysis.activeLentCount,
                debtAnalysis.overdueLentCount,
                Colors.green,
                Icons.arrow_upward,
                theme,
                t,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDebtSection(
    String title,
    double total,
    double remaining,
    int activeCount,
    int overdueCount,
    Color color,
    IconData icon,
    ThemeData theme,
    AppLocalizations t,
  ) {
    final paidAmount = total - remaining;
    final progressPercentage = total > 0 ? (paidAmount / total * 100) : 0;

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
          // Header
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.subtitle1.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (overdueCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$overdueCount ${t.overdue}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Amounts
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.total,
                      style: AppTextStyles.caption.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppTextStyles.currencySmall.copyWith(color: color),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.remaining,
                      style: AppTextStyles.caption.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${remaining.toStringAsFixed(2)}',
                      style: AppTextStyles.currencySmall.copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.paid,
                    style: AppTextStyles.caption.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                    ),
                  ),
                  Text(
                    '${progressPercentage.toStringAsFixed(1)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (progressPercentage / 100).clamp(0, 1),
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Active Debts Count
          Row(
            children: [
              Icon(
                Icons.people_outline,
                size: 16,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '$activeCount ${t.active}  ${title.toLowerCase()}',
                style: AppTextStyles.caption.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
