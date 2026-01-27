import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/utils/enum.dart';
import 'package:expense_mate/features/transcation/presentation/bloc/transcation_bloc/transcation_bloc.dart';
import 'package:expense_mate/features/transcation/presentation/bloc/transcation_bloc/transcation_event.dart';
import 'package:expense_mate/features/transcation/presentation/components/category_section/components/category_grid/components/category_grid_item.dart';
import 'package:expense_mate/features/transcation/presentation/faces/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryGrid extends StatelessWidget {
  final BudgetModel? budgetModel;
  final TransactionSource flowType;
  final List<CategoryHiveModel> categories;
  final List<CategoryHiveModel> selectedCategories;

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
      return const Center(
        child: Text('No Category found', style: TextStyle(fontSize: 16)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
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
