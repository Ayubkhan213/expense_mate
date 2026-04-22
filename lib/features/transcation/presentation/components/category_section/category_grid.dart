import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/core/utils/enum.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_bloc.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_event.dart';
import 'package:spendio/features/transcation/presentation/components/category_section/components/category_grid/components/category_grid_item.dart';
import 'package:spendio/features/transcation/presentation/faces/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/l10n/app_localizations.dart';

class CategoryGrid extends StatelessWidget {
  final BudgetModel? budgetModel;
  final TransactionSource flowType;
  final List<CategoryModel> categories;
  final List<CategoryModel> selectedCategories;

  const CategoryGrid({
    super.key,
    this.budgetModel,
    required this.flowType,
    required this.categories,
    required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      final t = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              t.noResultsFound,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.80,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategories.any((e) => e.key == category.key);

        return CategoryGridItem(
          category: category,
          isSelected: isSelected,

          onTap: () {
            context.read<TranscationBloc>().add(
              ToggleCategorySelection(selectedCategory: category),
            );

            if (!context.read<TranscationBloc>().state.isMultipleMode &&
                context
                    .read<TranscationBloc>()
                    .state
                    .selectedCategies!
                    .isEmpty) {
              CategoryBottomSheet.show(
                context,
                category,
                flowType,
                budgetModel,
                null,
              );
            }
          },
        );
      },
    );
  }
}
