// lib/features/debt/presentation/bloc/debt_repayment_state.dart

import 'package:expense_mate/core/data/models/debt_payment_model.dart';

abstract class DebtRepaymentState {}

class DebtRepaymentInitial extends DebtRepaymentState {}

class DebtRepaymentLoading extends DebtRepaymentState {}

class DebtRepaymentLoaded extends DebtRepaymentState {
  final List<DebtPaymentModel> payments;
  final double totalPaid;
  final double remainingAmount;

  DebtRepaymentLoaded({
    required this.payments,
    required this.totalPaid,
    required this.remainingAmount,
  });
}

class DebtRepaymentError extends DebtRepaymentState {
  final String message;
  DebtRepaymentError(this.message);
}
