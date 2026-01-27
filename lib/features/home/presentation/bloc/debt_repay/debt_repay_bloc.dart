// lib/features/debt/presentation/bloc/debt_repayment_bloc.dart

import 'package:expense_mate/features/home/domain/usecases/get_debtpayment_by_debtid_usecase.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebtRepaymentBloc extends Bloc<DebtRepaymentEvent, DebtRepaymentState> {
  final GetDebtPaymentsByDebtIdUseCase getDebtPaymentsByDebtIdUseCase;

  DebtRepaymentBloc({required this.getDebtPaymentsByDebtIdUseCase})
    : super(DebtRepaymentInitial()) {
    on<LoadDebtPayments>(_onLoadPayments);

    // on<DeleteDebtPayment>(_onDeletePayment);
  }

  Future<void> _onLoadPayments(
    LoadDebtPayments event,
    Emitter<DebtRepaymentState> emit,
  ) async {
    emit(DebtRepaymentLoading());
    try {
      final payments = getDebtPaymentsByDebtIdUseCase(event.debtModel.id);

      final totalPaid = payments.fold<double>(
        0.0,
        (sum, payment) => sum + payment.amount,
      );

      final remaining = event.debtModel.totalAmount - totalPaid;

      emit(
        DebtRepaymentLoaded(
          payments: payments,
          totalPaid: totalPaid,
          remainingAmount: remaining,
        ),
      );
    } catch (e) {
      emit(DebtRepaymentError(e.toString()));
    }
  }

  // Future<void> _onDeletePayment(
  //   DeleteDebtPayment event,
  //   Emitter<DebtRepaymentState> emit,
  // ) async {
  //   try {
  //     add(LoadDebtPayments(debtModel.id));
  //   } catch (e) {
  //     emit(DebtRepaymentError(e.toString()));
  //   }
  // }
}
