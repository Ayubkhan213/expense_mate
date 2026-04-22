import 'package:spendio/core/data/models/analytics_data_models.dart';
import 'package:spendio/core/utils/currency_formatter.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/core/utils/translation_helper.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendio/core/utils/icon_mapper.dart';

class CategoryChartCard extends StatelessWidget {
  final List<CategoryBreakdown> categoryBreakdown;

  const CategoryChartCard({super.key, required this.categoryBreakdown});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    if (categoryBreakdown.isEmpty) {
      return _buildEmptyState(theme);
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
              context.tr(t.expenseByCategory),
              style: AppTextStyles.h4.copyWith(
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 24),

            // Pie Chart
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  // Chart
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieSections(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),

                  // Legend
                  Expanded(flex: 2, child: _buildLegend(theme)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Category Details List
            _buildCategoryList(theme, context, t),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    return categoryBreakdown.take(6).map((category) {
      return PieChartSectionData(
        color: Color(category.colorValue),
        value: category.amount,
        title: '${category.percentage.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(ThemeData theme) {
    final topCategories = categoryBreakdown.take(6).toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: topCategories.length,
      itemBuilder: (context, index) {
        final category = topCategories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(category.colorValue),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.tr(category.categoryKey),
                  style: AppTextStyles.labelSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryList(
    ThemeData theme,
    BuildContext context,
    AppLocalizations t,
  ) {
    return Column(
      children: categoryBreakdown.take(8).map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(category.colorValue).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  IconMapper.getIcon(category.iconCode),
                  color: Color(category.colorValue),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Category name and count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(category.categoryKey),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${category.transactionCount} ${t.transactions} ',
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
                    CurrencyFormatter.format(category.amount),
                    style: AppTextStyles.currencyTiny.copyWith(
                      color: Color(category.colorValue),
                    ),
                  ),
                  Text(
                    '${category.percentage.toStringAsFixed(1)}%',
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

  Widget _buildEmptyState(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 64,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No expense data available',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
