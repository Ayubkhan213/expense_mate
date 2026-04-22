import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/utils/enum.dart';
import 'package:spendio/core/utils/translation_helper.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_bloc.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_event.dart';
import 'package:spendio/features/transcation/presentation/faces/category_bottom_sheet.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BudgetTransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final BudgetModel budget; // ✅ needed to reload details after edit/delete
  final VoidCallback? onTap;

  const BudgetTransactionCard({
    super.key,
    required this.transaction,
    required this.budget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context)!;

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
      onDismissed: (_) => _deleteTransaction(context),

      // ── Swipe right = edit ───────────────────────────────────────────
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit_rounded, color: Colors.white, size: 22),
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

      // ── Swipe left = delete ──────────────────────────────────────────
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_rounded, color: Colors.white, size: 22),
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

      child: _CardBody(transaction: transaction, onTap: onTap),
    );
  }

  void _openEditSheet(BuildContext context) {
    CategoryBottomSheet.show(
      context,
      null,
      TransactionSource.normal,
      null,
      null,
      existingTransaction: transaction,
    );
    // After edit, reload budget details
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.read<BudgetDetailsBloc>().add(
          LoadBudgetDetailsEvent(budget.id),
        );
      }
    });
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
    context.read<BudgetDetailsBloc>().add(
      DeleteBudgetTransactionEvent(
        transactionId: transaction.id,
        budgetId: budget.id,
        amount: transaction.totalAmount,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card body — unchanged UI
// ─────────────────────────────────────────────────────────────────────────────
class _CardBody extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const _CardBody({required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    final firstItem = transaction.items.isNotEmpty
        ? transaction.items.first
        : null;
    final isExpense = transaction.type.toString().contains('expense');
    final amount = transaction.totalAmount;
    final date = transaction.date;
    final paymentMethod = transaction.paymentMethod;
    final itemCount = transaction.items.length;

    final categoryLabel = firstItem?.category != null
        ? context.tr(firstItem!.category.toString())
        : t.transaction;

    final methodLabel = context.trMethod(
      paymentMethod.toString().split('.').last,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isExpense
                        ? const Color(0xFFef4444).withValues(alpha: 0.15)
                        : const Color(0xFF10b981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isExpense
                          ? const Color(0xFFef4444).withValues(alpha: 0.3)
                          : const Color(0xFF10b981).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getPaymentIcon(paymentMethod),
                    color: isExpense
                        ? const Color(0xFFef4444)
                        : const Color(0xFF10b981),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryLabel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd').format(date),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              methodLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isExpense ? '-' : '+'}${CurrencyFormatter.format(amount)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isExpense
                            ? const Color(0xFFef4444)
                            : const Color(0xFF10b981),
                      ),
                    ),
                    if (itemCount > 1) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${itemCount - 1} ${t.more}',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(dynamic method) {
    final s = method.toString().toLowerCase();
    if (s.contains('cash')) return Icons.money;
    if (s.contains('card')) return Icons.credit_card;
    if (s.contains('bank')) return Icons.account_balance;
    if (s.contains('wallet')) return Icons.wallet;
    return Icons.receipt;
  }

}
