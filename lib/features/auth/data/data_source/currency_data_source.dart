import 'package:hive/hive.dart';
import '../../../../core/data/models/currency_model.dart';

abstract class CurrencyLocalDataSource {
  Future<List<CurrencyModel>> getAllCurrencies();
  Future<CurrencyModel?> getCurrencyByCode(String code);
}

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  static const String _currencyBoxName = 'currencies';

  Box<CurrencyModel> get _currencyBox =>
      Hive.box<CurrencyModel>(_currencyBoxName);

  @override
  Future<List<CurrencyModel>> getAllCurrencies() async {
    try {
      return _currencyBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get currencies: $e');
    }
  }

  @override
  Future<CurrencyModel?> getCurrencyByCode(String code) async {
    try {
      return _currencyBox.get(code);
    } catch (e) {
      throw Exception('Failed to get currency: $e');
    }
  }
}
