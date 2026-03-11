import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/features/home/presentation/components/home_component/transcation_detail_face.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isIncome = transaction.type.toString().contains('income');
    final color = isIncome ? const Color(0xFF10b981) : const Color(0xFFef4444);
    final icon = _getIcon();
    final heroTag = 'txn_card_${transaction.id}';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, __, ___) =>
              TransactionDetailFace(transaction: transaction, heroTag: heroTag),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        ),
      ),
      child: Hero(
        tag: heroTag,
        flightShuttleBuilder: (_, anim, __, ___, ____) => Material(
          color: Colors.transparent,
          child: _CardBody(
            transaction: transaction,
            colorScheme: colorScheme,
            isDark: isDark,
            isIncome: isIncome,
            color: color,
            icon: icon,
            t: t,
          ),
        ),
        child: _CardBody(
          transaction: transaction,
          colorScheme: colorScheme,
          isDark: isDark,
          isIncome: isIncome,
          color: color,
          icon: icon,
          t: t,
        ),
      ),
    );
  }

  String _getIcon() {
    final category = transaction.items.first.category.toLowerCase();
    if (category.contains('food') || category.contains('restaurant'))
      return '🍔';
    if (category.contains('salary')) return '💰';
    if (category.contains('transport')) return '🚗';
    if (category.contains('shopping')) return '🛒';
    return '💵';
  }
}

class _CardBody extends StatelessWidget {
  final TransactionModel transaction;
  final ColorScheme colorScheme;
  final bool isDark;
  final bool isIncome;
  final Color color;
  final String icon;
  final AppLocalizations t;

  const _CardBody({
    required this.transaction,
    required this.colorScheme,
    required this.isDark,
    required this.isIncome,
    required this.color,
    required this.icon,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: transaction.isDebt
            ? Border.all(color: colorScheme.secondary.withValues(alpha: 0.4))
            : Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr(transaction.items.first.category),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (transaction.isDebt)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          t.debt.toUpperCase(),
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${DateFormat('MMM dd, yyyy').format(transaction.date)} • ${context.trMethod(transaction.paymentMethod.name)}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${transaction.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
