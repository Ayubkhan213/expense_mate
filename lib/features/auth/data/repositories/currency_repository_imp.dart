import 'package:spendio/core/data/models/currency_model.dart';
import 'package:spendio/features/auth/data/data_source/currency_local_datasource.dart';

import 'package:spendio/features/auth/domain/repository/sql/currency_repository.dart';

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
