import 'package:spendio/l10n/app_localizations.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class BudgetSummaryCard extends StatelessWidget {
  final String budgetName;
  final double totalAmount;
  final double totalSpent;
  final double remainingAmount;
  final double progressPercentage;
  final double availableHeight;
  final VoidCallback? onShare;
  final bool canShare;

  const BudgetSummaryCard({
    super.key,
    required this.budgetName,
    required this.totalAmount,
    required this.totalSpent,
    required this.remainingAmount,
    required this.progressPercentage,
    required this.availableHeight,
    this.onShare,
    this.canShare = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isOverBudget = remainingAmount < 0;
    final isNearLimit = progressPercentage > 0.8 && !isOverBudget;
    final t = AppLocalizations.of(context)!;

    return ClipRect(
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SizedBox(
          child: OverflowBox(
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 2),

                // ── Header row: back | label | status badge | share ──
                Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // "Total Budget" label
                    Expanded(
                      child: Text(
                        t.totalBudget,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          isOverBudget,
                          isNearLimit,
                        ).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(
                            isOverBudget,
                            isNearLimit,
                          ).withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _getStatusText(
                          isOverBudget,
                          isNearLimit,
                          progressPercentage,
                          t,
                        ),
                        style: TextStyle(
                          color: _getStatusColor(isOverBudget, isNearLimit),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Share button
                    GestureDetector(
                      onTap: canShare ? onShare : null,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: canShare ? 0.15 : 0.06,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.ios_share_rounded,
                          color: canShare ? Colors.white : Colors.white30,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Budget name
                Text(
                  budgetName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 4),

                // Total Amount
                Text(
                  CurrencyFormatter.format(totalAmount),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    shadows: isDark
                        ? null
                        : [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                  ),
                ),

                const SizedBox(height: 18),

                // Progress Bar with percentage label
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressPercentage.clamp(0.0, 1.0),
                          minHeight: 10,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isOverBudget
                                ? const Color(0xFFef4444)
                                : isNearLimit
                                ? const Color(0xFFf59e0b)
                                : const Color(0xFF10b981),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(progressPercentage * 100).clamp(0, 999).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Spent and Remaining Row
                Row(
                  children: [
                    Expanded(
                      child: _AmountBox(
                        label: t.spent,
                        amount: totalSpent,
                        color: const Color(0xFFef4444),
                        isDark: isDark,
                        icon: Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AmountBox(
                        label: t.remaining,
                        amount: remainingAmount.abs(),
                        color: isOverBudget
                            ? const Color(0xFFef4444)
                            : const Color(0xFF10b981),
                        isDark: isDark,
                        icon: isOverBudget
                            ? Icons.warning_rounded
                            : Icons.trending_down,
                        isNegative: isOverBudget,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(bool isOverBudget, bool isNearLimit) {
    if (isOverBudget) return const Color(0xFFef4444);
    if (isNearLimit) return const Color(0xFFf59e0b);
    return const Color(0xFF10b981);
  }

  String _getStatusText(
    bool isOverBudget,
    bool isNearLimit,
    double progress,
    AppLocalizations t,
  ) {
    if (isOverBudget) return t.overBudget;
    if (isNearLimit) return t.nearLimit;
    return '${(progress * 100).toStringAsFixed(0)}% ${t.used}';
  }

}

// ─────────────────────────────────────────────────────────────────────────────

class _AmountBox extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isDark;
  final IconData icon;
  final bool isNegative;

  const _AmountBox({
    required this.label,
    required this.amount,
    required this.color,
    required this.isDark,
    required this.icon,
    this.isNegative = false,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.85),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${isNegative ? '-' : ''}${CurrencyFormatter.format(amount)}',
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

}
