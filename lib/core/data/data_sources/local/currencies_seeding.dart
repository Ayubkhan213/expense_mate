import 'package:expense_mate/core/data/models/currency_model.dart';
import 'package:hive/hive.dart';

class CurrenciesSeeding {
  static const String currencyBox = 'currencies';

  /// Seed currencies on first launch
  static Future<void> seedCurrenciesIfFirstTime() async {
    final box = Hive.box<CurrencyModel>(currencyBox);

    if (box.isEmpty) {
      print('🌍 Seeding currencies...');
      for (var currency in CurrencyList.currencies) {
        await box.put(currency.code, currency);
      }
      print('✅ ${box.length} currencies seeded!');
    }
  }
}
