import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/utils/translation_helper.dart';
import 'package:spendio/features/home/presentation/components/home_component/transcation_detail_face.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:spendio/core/utils/enum.dart';
import 'package:spendio/features/transcation/presentation/faces/category_bottom_sheet.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/models/transcation_sql_model.dart';

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

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteDialog(context, t);
        } else {
          _openEditSheet(context);
          return false;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _deleteTransaction(context);
        }
      },
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              t.edit,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              t.delete,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 450),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (_, __, ___) => TransactionDetailFace(
              transaction: transaction,
              heroTag: heroTag,
            ),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
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
      ),
    );
  }

  void _openEditSheet(BuildContext context) {
    CategoryBottomSheet.show(
      context,
      transaction.items.isNotEmpty
          ? null // category resolved inside sheet from transaction
          : null,
      TransactionSource.normal,
      null,
      null,
      existingTransaction: transaction, // pass existing data
    );
  }

  Future<bool> _showDeleteDialog(
    BuildContext context,
    AppLocalizations t,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(t.deleteTransaction),
            content: Text(t.deleteTransactionConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(t.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  t.delete,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _deleteTransaction(BuildContext context) {
    context.read<HomeBloc>().add(
      DeleteTransaction(transactionId: transaction.id),
    );
  }

  String _getIcon() {
    if (transaction.items.isEmpty) return '💵';
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
            '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.totalAmount)}',
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
