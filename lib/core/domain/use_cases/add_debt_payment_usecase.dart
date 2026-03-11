import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';

import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/repository/sql/transcation_repository.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

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
