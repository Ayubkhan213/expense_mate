import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/utils/utils.dart';
import 'package:hive/hive.dart';

class CategorySeeder {
  static const String categoryBox = 'categories';

  static Future<void> seedIfFirstTime() async {
    final box = Hive.box<CategoryHiveModel>(categoryBox);

    //  If data already exists → DO NOTHING
    if (box.isNotEmpty) return;

    final utils = Utils();

    //  Income categories
    for (final item in utils.incomeCategories) {
      await box.add(
        CategoryHiveModel(
          key: item.keyName,
          iconCode: item.icon.codePoint,
          colorValue: item.color.value,
          isIncome: true,
        ),
      );
    }

    //  Expense categories
    for (final item in utils.expenseCategories) {
      await box.add(
        CategoryHiveModel(
          key: item.keyName,
          iconCode: item.icon.codePoint,
          colorValue: item.color.value,
          isIncome: false,
        ),
      );
    }
  }
}
