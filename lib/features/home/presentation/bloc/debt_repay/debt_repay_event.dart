import 'package:equatable/equatable.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';

abstract class DebtRepaymentEvent extends Equatable {
  const DebtRepaymentEvent();
  @override
  List<Object?> get props => [];
}

class LoadDebtPayments extends DebtRepaymentEvent {
  final DebtModel debtModel;
  const LoadDebtPayments({required this.debtModel});
  @override
  List<Object?> get props => [debtModel.id];
}

// ✅ NEW — delete a payment
class DeleteDebtPayment extends DebtRepaymentEvent {
  final DebtPaymentModel payment;
  final DebtModel debtModel;
  const DeleteDebtPayment({required this.payment, required this.debtModel});
  @override
  List<Object?> get props => [payment.id];
}
