import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/extension/responsive_extension.dart';
import 'package:spendio/features/home/presentation/components/home_component/debt_card.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DebtsList extends StatelessWidget {
  final List<DebtModel> debts;

  const DebtsList({super.key, required this.debts});

  @override
  Widget build(BuildContext context) {
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
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 64,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            t.noActiveDebts,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.debtManagementStarts,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 200.0),
        ],
      ),
    );
  }
}
