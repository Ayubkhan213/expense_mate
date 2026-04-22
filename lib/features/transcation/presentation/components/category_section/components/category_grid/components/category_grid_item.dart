import 'package:flutter/material.dart';
import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/core/utils/translation_helper.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryGridItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? category.color : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              category.icon,
              color: isSelected ? Colors.white : category.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(category.key),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
