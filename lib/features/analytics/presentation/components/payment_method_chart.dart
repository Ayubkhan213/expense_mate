import 'package:expense_mate/core/data/models/analytics_data_models.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PaymentMethodChart extends StatelessWidget {
  final PaymentMethodBreakdown paymentMethodBreakdown;

  const PaymentMethodChart({super.key, required this.paymentMethodBreakdown});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (paymentMethodBreakdown.methodAmounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Methods',
              style: AppTextStyles.h4.copyWith(
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Distribution of payment methods',
              style: AppTextStyles.caption.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            // Donut Chart
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieSections(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: _buildLegend(theme)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Payment Method Details
            _buildPaymentMethodList(theme),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final colors = _getPaymentMethodColors();
    final entries = paymentMethodBreakdown.methodAmounts.entries.toList();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = (item.value / total * 100);

      return PieChartSectionData(
        color: colors[item.key] ?? Colors.grey,
        value: item.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(ThemeData theme) {
    final colors = _getPaymentMethodColors();
    final entries = paymentMethodBreakdown.methodAmounts.entries.toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[entry.key] ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _capitalize(entry.key),
                  style: AppTextStyles.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodList(ThemeData theme) {
    final colors = _getPaymentMethodColors();
    final icons = _getPaymentMethodIcons();
    final entries = paymentMethodBreakdown.methodAmounts.entries.toList();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value);

    return Column(
      children: entries.map((entry) {
        final method = entry.key;
        final amount = entry.value;
        final count = paymentMethodBreakdown.methodCounts[method] ?? 0;
        final percentage = (amount / total * 100);
        final color = colors[method] ?? Colors.grey;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icons[method] ?? Icons.payment,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Method name and count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _capitalize(method),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$count transactions',
                      style: AppTextStyles.caption.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount and percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: AppTextStyles.currencyTiny.copyWith(color: color),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, Color> _getPaymentMethodColors() {
    return {
      'cash': Colors.green,
      'card': Colors.blue,
      'bank': Colors.purple,
      'wallet': Colors.orange,
    };
  }

  Map<String, IconData> _getPaymentMethodIcons() {
    return {
      'cash': Icons.money,
      'card': Icons.credit_card,
      'bank': Icons.account_balance,
      'wallet': Icons.account_balance_wallet,
    };
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
