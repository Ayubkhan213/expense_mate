import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/features/home/domain/repository/sql/home_repository.dart';

class GetDebtPaymentsByDebtIdUseCase {
  final HomeRepository repository;

  GetDebtPaymentsByDebtIdUseCase({required this.repository});

  Future<List<DebtPaymentModel>> call(String debtId) async {
    if (debtId.isEmpty) {
      return [];
    }

    return repository.getPaymentsByDebtId(debtId);
  }
}
