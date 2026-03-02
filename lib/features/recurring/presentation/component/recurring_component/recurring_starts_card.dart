import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_state.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Stats card showing active, due soon, and monthly estimates
class RecurringStatsCard extends StatelessWidget {
  final RecurringStats stats;

  const RecurringStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: t.active,
                  value: stats.totalActive.toString(),
                  icon: Icons.check_circle,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: t.dueSoon,
                  value: stats.dueThisWeek.toString(),
                  icon: Icons.schedule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MonthlyEstimate(
                  label: 'Monthly Income',
                  amount: stats.monthlyIncomeEstimate,
                  isIncome: true,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(
                child: _MonthlyEstimate(
                  label: 'Monthly Expense',
                  amount: stats.monthlyExpenseEstimate,
                  isIncome: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNetMonthly(stats.netMonthly, t),
        ],
      ),
    );
  }

  Widget _buildNetMonthly(double netMonthly, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: netMonthly >= 0
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            netMonthly >= 0 ? Icons.trending_up : Icons.trending_down,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Net: ${netMonthly >= 0 ? '+' : ''}${netMonthly.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }
}

class _MonthlyEstimate extends StatelessWidget {
  final String label;
  final double amount;
  final bool isIncome;

  const _MonthlyEstimate({
    required this.label,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          '${isIncome ? '+' : '-'}${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
