import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/analytics_data_models.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopTransactionsCard extends StatelessWidget {
  final List<TopTransaction> topTransactions;

  const TopTransactionsCard({super.key, required this.topTransactions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (topTransactions.isEmpty) {
      return const SizedBox.shrink();
    }
    final t = AppLocalizations.of(context)!;

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
                  t.topExpenses,
                  style: AppTextStyles.h4.copyWith(
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  '${t.top} ${topTransactions.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Transaction List
            ...topTransactions.asMap().entries.map((entry) {
              final index = entry.key;
              final transaction = entry.value;
              return _buildTransactionItem(
                index + 1,
                transaction,
                theme,
                context,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    int rank,
    TopTransaction transaction,
    ThemeData theme,
    BuildContext context,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(transaction.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: rank <= 3
              ? Border.all(
                  color: _getRankColor(rank).withOpacity(0.3),
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rank <= 3
                    ? _getRankColor(rank)
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: rank <= 3
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capitalize(context.tr(transaction.categoryKey)),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: AppTextStyles.caption.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (transaction.note != null &&
                      transaction.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      transaction.note!,
                      style: AppTextStyles.caption.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.5,
                        ),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Amount
            Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: AppTextStyles.currencyTiny.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey.shade400; // Silver
      case 3:
        return Colors.brown.shade300; // Bronze
      default:
        return Colors.grey;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
