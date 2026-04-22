import 'package:flutter/material.dart';

import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/features/recurring/presentation/component/recurring_category/recurring_category_card.dart';
import 'package:spendio/l10n/app_localizations.dart';

class RecurringCategoryGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final bool isIncome;

  const RecurringCategoryGrid({
    super.key,
    required this.categories,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No categories found',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Add categories to create recurring transactions',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return RecurringCategoryCard(category: category);
      },
    );
  }
}
