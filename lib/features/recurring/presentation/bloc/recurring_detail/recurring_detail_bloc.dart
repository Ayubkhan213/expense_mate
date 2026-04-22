import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/features/recurring/domain/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'recurring_detail_event.dart';
import 'recurring_detail_state.dart';

class RecurringDetailBloc
    extends Bloc<RecurringDetailEvent, RecurringDetailState> {
  final RecurringRepository repository;

  RecurringDetailBloc({required this.repository})
    : super(RecurringDetailInitial()) {
    on<LoadRecurringDetail>(_onLoad);
    on<RefreshRecurringDetail>(_onRefresh);
  }

  Future<void> _onLoad(
    LoadRecurringDetail event,
    Emitter<RecurringDetailState> emit,
  ) async {
    emit(RecurringDetailLoading());
    await _loadDetail(event.recurringId, emit);
  }

  Future<void> _onRefresh(
    RefreshRecurringDetail event,
    Emitter<RecurringDetailState> emit,
  ) async {
    await _loadDetail(event.recurringId, emit);
  }

  Future<void> _loadDetail(
    String recurringId,
    Emitter<RecurringDetailState> emit,
  ) async {
    try {
      final recurring = await repository.getRecurringById(recurringId);
      if (recurring == null) {
        emit(const RecurringDetailError('Recurring transaction not found'));
        return;
      }

      final generatedTransactions = await repository.getGeneratedTransactions(
        recurring.generatedTransactionIds,
      );

      final totalSpent = generatedTransactions.fold<double>(
        0,
        (sum, t) => sum + t.totalAmount,
      );

      emit(
        RecurringDetailLoaded(
          recurring: recurring,
          generatedTransactions: generatedTransactions,
          totalSpent: totalSpent,
          monthlyEstimate: _calculateMonthlyAmount(recurring),
        ),
      );
    } catch (e) {
      emit(RecurringDetailError(e.toString()));
    }
  }

  double _calculateMonthlyAmount(recurring) {
    switch (recurring.frequency) {
      case RecurrenceFrequency.daily:
        return recurring.amount * 30;
      case RecurrenceFrequency.weekly:
        return recurring.amount * 4.33;
      case RecurrenceFrequency.biweekly:
        return recurring.amount * 2.17;
      case RecurrenceFrequency.monthly:
        return recurring.amount;
      case RecurrenceFrequency.quarterly:
        return recurring.amount / 3;
      case RecurrenceFrequency.yearly:
        return recurring.amount / 12;
      default:
        return recurring.amount;
    }
  }
}
