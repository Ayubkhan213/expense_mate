import 'package:flutter/material.dart';

class QuickCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Color accentColor;
  final Function(String) onCategorySelected;

  const QuickCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.accentColor,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Select',
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategory == category;
            return _buildCategoryChip(
              context,
              category,
              isSelected,
              colorScheme,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String category,
    bool isSelected,
    ColorScheme colorScheme,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.15)
              : (isDark ? colorScheme.surface : Colors.grey[100]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? accentColor
                : colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? accentColor : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
