import 'package:expense_mate/core/app_export.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: 5)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String key; // salary, food, etc (used for translation)

  @HiveField(1)
  final int iconCode; // Icons.xxx.codePoint

  @HiveField(2)
  final int colorValue; // Color.value

  @HiveField(3)
  final bool isIncome; // true = income, false = expense

  CategoryHiveModel({
    required this.key,
    required this.iconCode,
    required this.colorValue,
    required this.isIncome,
  });
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  Color get color => Color(colorValue);
}
