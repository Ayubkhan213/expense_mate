import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisplaySection extends StatelessWidget {
  final String display;
  final bool isDebt;
  final dynamic debtType; // DebtType enum
  final dynamic transactionType; // TransactionType enum
  final bool showDebtToggle;
  final VoidCallback onDebtToggle;
  final bool alignRight;

  const DisplaySection({
    super.key,
    required this.display,
    required this.isDebt,
    required this.debtType,
    required this.transactionType,
    required this.showDebtToggle,
    required this.onDebtToggle,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: alignRight
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (showDebtToggle) ...[
            _DebtBadge(
              isDebt: isDebt,
              debtType: debtType,
              transactionType: transactionType,
              onTap: () {
                HapticFeedback.lightImpact();
                onDebtToggle();
              },
              colorScheme: colorScheme,
            ),
            const Spacer(),
          ],
          Text(
            display,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtBadge extends StatelessWidget {
  final bool isDebt;
  final dynamic debtType;
  final dynamic transactionType;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _DebtBadge({
    required this.isDebt,
    required this.debtType,
    required this.transactionType,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isBorrowed = debtType.toString().contains('borrowed');
    final isExpense = transactionType.toString().contains('expense');
    final badgeColor = isDebt
        ? (isBorrowed ? const Color(0xFFef4444) : const Color(0xFF10b981))
        : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: badgeColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isExpense ? '💰' : '💸', style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              isExpense ? t.borrowed : t.lent,
              style: TextStyle(
                color: badgeColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
