import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/transcation_result.dart';

import '../repository/sql/transcation_repository.dart';

class AddDebtPaymentUseCase {
  final TransactionRepository repository;

  AddDebtPaymentUseCase({required this.repository});

  Future<TransactionResult> call({
    required DebtPaymentModel paymentmodel,
    required DebtModel debtModel,
  }) async {
    if (paymentmodel.amount > debtModel.remainingAmount) {
      return TransactionResult(
        success: false,
        message: 'Payment exceeds remaining debt',
      );
    }

    return repository.addDebtPayment(paymentmodel);
  }
}
