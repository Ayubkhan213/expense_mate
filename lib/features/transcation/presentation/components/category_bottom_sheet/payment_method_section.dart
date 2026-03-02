import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final Function(PaymentMethod) onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          PaymentMethodChip(
            icon: Icons.money,
            label: t.cash,
            selected: selectedMethod == PaymentMethod.cash,
            value: PaymentMethod.cash,
            onTap: onMethodChanged,
          ),
          PaymentMethodChip(
            icon: Icons.credit_card,
            label: t.card,
            selected: selectedMethod == PaymentMethod.card,
            value: PaymentMethod.card,
            onTap: onMethodChanged,
          ),
          PaymentMethodChip(
            icon: Icons.account_balance,
            label: t.bank,
            selected: selectedMethod == PaymentMethod.bank,
            value: PaymentMethod.bank,
            onTap: onMethodChanged,
          ),
          PaymentMethodChip(
            icon: Icons.wallet,
            label: t.wallet,
            selected: selectedMethod == PaymentMethod.wallet,
            value: PaymentMethod.wallet,
            onTap: onMethodChanged,
          ),
        ],
      ),
    );
  }
}

class PaymentMethodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final PaymentMethod value;
  final Function(PaymentMethod) onTap;

  const PaymentMethodChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onTap(value), // ✅ enum returned
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary
              : (isDark ? colorScheme.surface : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: selected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
