import 'package:expense_mate/core/app_export.dart';
import 'components/category_grid_item.dart';
import 'components/category_bottom_sheet/category_bottom_sheet.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryHiveModel> categories;
  final List<CategoryHiveModel> selectedCategories;

  const CategoryGrid({
    super.key,
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
            context.read<AddRecordBloc>().add(
              ToggleCategorySelection(selectedCategory: category),
            );

            if (!context.read<AddRecordBloc>().state.isMultipleMode) {
              CategoryBottomSheet.show(context, category);
            }
          },
        );
      },
    );
  }
}
