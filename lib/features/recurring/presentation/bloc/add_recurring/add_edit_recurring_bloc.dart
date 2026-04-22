import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/recurring_transcation_sql_model.dart';
import 'package:spendio/core/services/app_prefs.dart';
import 'package:spendio/core/services/recurring_background_service.dart';
import 'package:spendio/core/services/recurring_background_sql_services.dart';
import 'package:spendio/features/recurring/domain/repository.dart';
import 'package:spendio/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';
import 'package:spendio/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddEditRecurringBloc
    extends Bloc<AddEditRecurringEvent, AddEditRecurringState> {
  final RecurringRepository repository;
  final _uuid = const Uuid();

  AddEditRecurringBloc({required this.repository})
    : super(AddEditRecurringState()) {
    on<InitializeForm>(_onInitialize);
    on<TransactionTypeChanged>(_onTypeChanged);
    on<AmountChanged>(_onAmountChanged);
    on<CategoryChanged>(_onCategoryChanged);
    on<FrequencyChanged>(_onFrequencyChanged);
    on<PaymentMethodChanged>(_onPaymentChanged);
    on<StartDateChanged>(_onStartDateChanged);
    on<EndDateChanged>(_onEndDateChanged);
    on<DayOfMonthChanged>(_onDayOfMonthChanged);
    on<NoteChanged>(_onNoteChanged);
    on<SubmitRecurring>(_onSubmit);
    on<ResetForm>(_onReset);
    on<CalculatorNumberPressed>(_onCalculatorNumber);
    on<CalculatorOperationPressed>(_onCalculatorOperation);
    on<CalculatorEqualsPressed>(_onCalculatorEquals);
    on<CalculatorClearPressed>(_onCalculatorClear);
  }

  void _onInitialize(
    InitializeForm event,
    Emitter<AddEditRecurringState> emit,
  ) {
    if (event.existing != null) {
      // Edit mode - populate with existing data
      final existing = event.existing!;
      emit(
        state.copyWith(
          categoryKey: existing.categoryKey,
          amount: existing.amount.toString(),
          transactionType: existing.type,
          frequency: existing.frequency,
          paymentMethod: existing.paymentMethod,
          startDate: existing.startDate,
          endDate: existing.endDate,
          dayOfMonth: existing.dayOfMonth,
          dayOfWeek: existing.dayOfWeek,
          note: existing.note ?? '',
          recurringId: existing.id,
        ),
      );
    } else {
      // Add mode - set category and type
      emit(
        state.copyWith(
          categoryKey: event.category.key,
          transactionType: event.category.isIncome
              ? TransactionType.income
              : TransactionType.expense,
        ),
      );
    }
  }

  void _onTypeChanged(
    TransactionTypeChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    final newCategory = event.type == TransactionType.income
        ? 'salary'
        : 'rent';
    emit(state.copyWith(transactionType: event.type, categoryKey: newCategory));
  }

  void _onAmountChanged(
    AmountChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onCategoryChanged(
    CategoryChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    emit(state.copyWith(categoryKey: event.categoryKey));
  }

  void _onFrequencyChanged(
    FrequencyChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    emit(state.copyWith(frequency: event.frequency));
  }

  void _onPaymentChanged(
    PaymentMethodChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  void _onStartDateChanged(
    StartDateChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    emit(state.copyWith(startDate: event.date));
  }

  void _onEndDateChanged(
    EndDateChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    emit(state.copyWith(endDate: event.date));
  }

  void _onDayOfMonthChanged(
    DayOfMonthChanged event,
    Emitter<AddEditRecurringState> emit,
  ) {
    emit(state.copyWith(dayOfMonth: event.day));
  }

  void _onNoteChanged(NoteChanged event, Emitter<AddEditRecurringState> emit) {
    emit(state.copyWith(note: event.note));
  }

  // Calculator handlers
  void _onCalculatorNumber(
    CalculatorNumberPressed event,
    Emitter<AddEditRecurringState> emit,
  ) {
    String newNumber = state.currentNumber;
    if (newNumber == '0' || newNumber.isEmpty) {
      newNumber = event.number;
    } else {
      newNumber += event.number;
    }

    emit(state.copyWith(currentNumber: newNumber, amount: newNumber));
  }

  void _onCalculatorOperation(
    CalculatorOperationPressed event,
    Emitter<AddEditRecurringState> emit,
  ) {
    if (state.currentNumber.isEmpty) return;

    emit(
      state.copyWith(
        previousNumber: state.currentNumber,
        currentNumber: '',
        operation: event.operation,
      ),
    );
  }

  void _onCalculatorEquals(
    CalculatorEqualsPressed event,
    Emitter<AddEditRecurringState> emit,
  ) {
    if (state.previousNumber.isEmpty || state.currentNumber.isEmpty) return;

    final prev = double.tryParse(state.previousNumber) ?? 0;
    final curr = double.tryParse(state.currentNumber) ?? 0;
    double result = 0;

    if (state.operation == '+') {
      result = prev + curr;
    } else if (state.operation == '-') {
      result = prev - curr;
    }

    final resultStr = result.toStringAsFixed(2);

    emit(
      state.copyWith(
        currentNumber: resultStr,
        previousNumber: '',
        operation: '',
        amount: resultStr,
      ),
    );
  }

  void _onCalculatorClear(
    CalculatorClearPressed event,
    Emitter<AddEditRecurringState> emit,
  ) {
    if (state.currentNumber.isNotEmpty) {
      final newNumber = state.currentNumber.substring(
        0,
        state.currentNumber.length - 1,
      );

      emit(
        state.copyWith(
          currentNumber: newNumber,
          amount: newNumber.isEmpty ? '0' : newNumber,
        ),
      );
    }
  }

  Future<void> _onSubmit(
    SubmitRecurring event,
    Emitter<AddEditRecurringState> emit,
  ) async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          status: RecurringFormStatus.error,
          errorMessage: 'Please enter a valid amount',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RecurringFormStatus.loading));

    try {
      final recurring = RecurringTransactionModel(
        id: state.recurringId == '' || state.recurringId == null
            ? _uuid.v4()
            : state.recurringId,
        categoryKey: state.categoryKey,
        amount: double.parse(state.amount),
        note: state.note.isEmpty ? null : state.note,
        frequency: state.frequency,
        type: state.transactionType,
        userId: AppPrefs.instance.userId,
        paymentMethod: state.paymentMethod,
        startDate: state.startDate,
        endDate: state.endDate,
        nextOccurrence: state.startDate,
        dayOfMonth: state.dayOfMonth,
        dayOfWeek: state.dayOfWeek,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (state.recurringId != null && state.recurringId != '') {
        await repository.updateRecurring(recurring);
      } else {
        await repository.createRecurring(recurring);
      }

      // Trigger immediate processing
      await RecurringBackgroundService.processRecurringTransactions();

      emit(state.copyWith(status: RecurringFormStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: RecurringFormStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onReset(ResetForm event, Emitter<AddEditRecurringState> emit) {
    emit(AddEditRecurringState());
  }
}
