import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/extension/responsive_extension.dart';
import 'package:expense_mate/features/home/presentation/components/home_component/debt_card.dart';
import 'package:flutter/material.dart';

class DebtsList extends StatelessWidget {
  final List<DebtModel> debts; // Replace with List<DebtModel>

  const DebtsList({super.key, required this.debts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (debts.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        ...debts.map((debt) => DebtCard(debt: debt)).toList(),
        200.h.sh,
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.2),
          ),
          SizedBox(height: 16),
          Text(
            'No active debts',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your debt management starts here',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 200.0),
        ],
      ),
    );
  }
}
