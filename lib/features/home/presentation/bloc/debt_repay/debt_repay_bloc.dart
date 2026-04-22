import 'package:spendio/core/data/data_sources/local/debt_local_datasource.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/features/home/domain/usecases/get_debtpayment_by_debtid_usecase.dart';
import 'package:spendio/features/home/presentation/bloc/debt_repay/debt_repay_event.dart';
import 'package:spendio/features/home/presentation/bloc/debt_repay/debt_repay_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebtRepaymentBloc extends Bloc<DebtRepaymentEvent, DebtRepaymentState> {
  final GetDebtPaymentsByDebtIdUseCase getDebtPaymentsByDebtIdUseCase;

  DebtRepaymentBloc({required this.getDebtPaymentsByDebtIdUseCase})
    : super(DebtRepaymentInitial()) {
    on<LoadDebtPayments>(_onLoadPayments);
    on<DeleteDebtPayment>(_onDeletePayment); // ✅ NEW
  }

  Future<void> _onLoadPayments(
    LoadDebtPayments event,
    Emitter<DebtRepaymentState> emit,
  ) async {
    emit(DebtRepaymentLoading());
    try {
      final payments = await getDebtPaymentsByDebtIdUseCase(event.debtModel.id);

      final totalPaid = payments.fold<double>(0.0, (sum, p) => sum + p.amount);

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

  Future<void> _onDeletePayment(
    DeleteDebtPayment event,
    Emitter<DebtRepaymentState> emit,
  ) async {
    try {
      // 1. Delete payment via repo
      await getDebtPaymentsByDebtIdUseCase.repository.deleteDebtPayment(
        event.payment.id,
      );

      // 2. Recalculate
      final remaining = event.debtModel.paidAmount - event.payment.amount;
      final newPaid = remaining < 0 ? 0.0 : remaining;
      final updatedDebt = (event.debtModel as DebtModel).copyWith(
        paidAmount: newPaid,
        isReturned: false,
        updatedAt: DateTime.now(),
      );

      // 3. Update debt via repo
      await getDebtPaymentsByDebtIdUseCase.repository.updateDebt(updatedDebt);

      // 4. Reload
      add(LoadDebtPayments(debtModel: updatedDebt));
    } catch (e) {
      emit(DebtRepaymentError(e.toString()));
    }
  }
}
