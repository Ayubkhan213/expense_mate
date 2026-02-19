import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';

/// Payment method selector dropdown
class RecurringPaymentDropdown extends StatelessWidget {
  final PaymentMethod payment;

  const RecurringPaymentDropdown({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<AddEditRecurringBloc>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaymentMethod>(
          value: payment,
          isExpanded: true,
          isDense: true,
          icon: const Icon(Icons.expand_more, size: 18),
          items: _buildItems(theme),
          onChanged: (val) {
            if (val != null) bloc.add(PaymentMethodChanged(val));
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<PaymentMethod>> _buildItems(ThemeData theme) {
    return PaymentMethod.values.map((method) {
      return DropdownMenuItem(
        value: method,
        child: Row(
          children: [
            Icon(_getPaymentIcon(method), size: 14, color: theme.primaryColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _getPaymentLabel(method),
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getPaymentLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.bank:
        return 'Bank';
      case PaymentMethod.wallet:
        return 'Wallet';
      default:
        return 'Other';
    }
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.bank:
        return Icons.account_balance;
      case PaymentMethod.wallet:
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }
}
