import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:spendio/features/home/presentation/components/debt_edit_sheet.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DebtCard extends StatelessWidget {
  final DebtModel debt;

  const DebtCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(debt.id),
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
          context.read<HomeBloc>().add(DeleteDebt(debt: debt));
        }
      },

      // ── Swipe right = edit ───────────────────────────────────────────
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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

      // ── Swipe left = delete ──────────────────────────────────────────
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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

      child: _DebtCardBody(debt: debt),
    );
  }

  void _openEditSheet(BuildContext context) {
    DebtEditSheet.show(context, debt); // ✅ dedicated edit sheet
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
            content: const Text(
              'This will also delete all repayments and the linked transaction. This cannot be undone.',
            ),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Card body — extracted so Dismissible child stays clean
// ─────────────────────────────────────────────────────────────────────────────
class _DebtCardBody extends StatelessWidget {
  final DebtModel debt;
  const _DebtCardBody({required this.debt});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final debtType = debt.debtType;
    final color = debtType.toString().contains('borrowed')
        ? const Color(0xFFef4444)
        : const Color(0xFF10b981);
    final isOverdue = debt.isOverdue ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue
              ? Colors.red.withValues(alpha: 0.5)
              : color.withValues(alpha: 0.3),
          width: isOverdue ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  debtType.toString().contains('borrowed')
                      ? Icons.trending_down
                      : Icons.trending_up,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      debtType.toString().contains('borrowed')
                          ? '${t.borrowedFrom} ${debt.personName}'
                          : '${t.lentTo} ${debt.personName}',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${CurrencyFormatter.format(debt.remainingAmount)} ${t.remaining}',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Action
              IconButton(
                icon: Icon(Icons.add_circle, color: colorScheme.secondary),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteName.debtRepayment,
                    arguments: {'debt': debt},
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: debt.paymentPercentage / 100,
              minHeight: 6,
              backgroundColor: isDark
                  ? colorScheme.surface.withValues(alpha: 0.3)
                  : Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 8),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${debt.paymentPercentage.toStringAsFixed(0)}% ${t.paid}',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isOverdue)
                Text(
                  '⚠️ ${debt.daysOverdue} ${t.daysOverdue}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Text(
                  '${t.due}: ${DateFormat('MMM dd').format(debt.expectedReturnDate)}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
