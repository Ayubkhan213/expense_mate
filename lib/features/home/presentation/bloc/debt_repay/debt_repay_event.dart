// lib/features/debt/presentation/bloc/debt_repayment_event.dart

import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';

abstract class DebtRepaymentEvent {}

class LoadDebtPayments extends DebtRepaymentEvent {
  final DebtModel debtModel;
  LoadDebtPayments({required this.debtModel});
}

class AddDebtPayment extends DebtRepaymentEvent {
  final DebtPaymentModel payment;
  AddDebtPayment(this.payment);
}

class DeleteDebtPayment extends DebtRepaymentEvent {
  final String paymentId;
  DeleteDebtPayment(this.paymentId);
}
