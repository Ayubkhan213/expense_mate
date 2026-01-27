import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/features/home/domain/repository/home_repository.dart';

class GetDebtPaymentsByDebtIdUseCase {
  final HomeRepository repository;

  GetDebtPaymentsByDebtIdUseCase({required this.repository});

  List<DebtPaymentModel> call(String debtId) {
    if (debtId.isEmpty) {
      return [];
    }

    return repository.getPaymentsByDebtId(debtId);
  }
}
