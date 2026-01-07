import 'package:expense_mate/features/auth/domain/repository/currency_repository.dart';

import '../../../../core/data/models/currency_model.dart';

class GetCurrencyByCodeUseCase {
  final CurrencyRepository repository;

  GetCurrencyByCodeUseCase(this.repository);

  Future<CurrencyModel?> call(String code) async {
    return await repository.getCurrencyByCode(code);
  }
}
