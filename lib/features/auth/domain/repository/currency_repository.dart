import '../../../../core/data/models/currency_model.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyModel>> getAllCurrencies();
  Future<CurrencyModel?> getCurrencyByCode(String code);
}
