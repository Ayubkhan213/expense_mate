import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/features/home/presentation/bloc/debt_repay/debt_repay_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/debt_repay/debt_repay_event.dart';
import 'package:spendio/l10n/app_localizations.dart';

class PaymentListItem extends StatelessWidget {
  final DebtPaymentModel payment;
  final DebtModel debtModel; // ✅ needed for bloc event
  final VoidCallback? onDelete;

  const PaymentListItem({
    super.key,
    required this.payment,
    required this.debtModel,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = colorScheme.primary;

    return Dismissible(
      key: Key(payment.id),
      direction: DismissDirection.endToStart, // swipe left only = delete
      confirmDismiss: (_) async => _showDeleteDialog(context, t),
      onDismissed: (_) {
        context.read<DebtRepaymentBloc>().add(
          DeleteDebtPayment(payment: payment, debtModel: debtModel),
        );
      },
      // ── Delete background ──────────────────────────────────────────
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(14),
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(Icons.payments_outlined, color: primary, size: 20),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.payment,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${DateFormat('MMM dd, yyyy').format(payment.paymentDate)} · ${payment.paymentMethod.name}',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Amount + delete button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+${CurrencyFormatter.format(payment.amount)}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: const Color(0xFF10b981),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '← swipe',
                  style: AppTextStyles.overline.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
            title: Text(t.deletePayment),
            content: Text(t.deletePaymentConfirm),
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
