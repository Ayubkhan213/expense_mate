import 'package:expense_mate/features/auth/data/data_source/currency_data_source.dart';
import 'package:expense_mate/features/auth/domain/repository/currency_repository.dart';

import '../../../../core/data/models/currency_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CurrencyModel>> getAllCurrencies() async {
    try {
      return await localDataSource.getAllCurrencies();
    } catch (e) {
      throw Exception('Failed to fetch currencies: $e');
    }
  }

  @override
  Future<CurrencyModel?> getCurrencyByCode(String code) async {
    try {
      return await localDataSource.getCurrencyByCode(code);
    } catch (e) {
      throw Exception('Failed to fetch currency: $e');
    }
  }
}
