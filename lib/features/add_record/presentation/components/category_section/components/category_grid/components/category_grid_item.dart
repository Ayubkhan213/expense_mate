import 'package:expense_mate/core/app_export.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoryHiveModel category;
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
            height: 64,
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
