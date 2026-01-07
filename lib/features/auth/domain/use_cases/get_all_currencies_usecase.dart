import 'package:expense_mate/features/auth/domain/repository/currency_repository.dart';

import '../../../../core/data/models/currency_model.dart';

class GetAllCurrenciesUseCase {
  final CurrencyRepository repository;

  GetAllCurrenciesUseCase(this.repository);

  Future<List<CurrencyModel>> call() async {
    return await repository.getAllCurrencies();
  }
}
