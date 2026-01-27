// Budget Form BLoC
import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';

class BudgetFormBloc extends Bloc<BudgetFormEvent, BudgetFormState> {
  BudgetFormBloc() : super(BudgetFormState.initial()) {
    on<BudgetFormTypeChanged>(_onTypeChanged);
    on<BudgetFormCategorySelected>(_onCategorySelected);
    on<BudgetFormColorChanged>(_onColorChanged);
    on<BudgetFormIconChanged>(_onIconChanged);
    on<BudgetFormStartDateChanged>(_onStartDateChanged);
    on<BudgetFormEndDateChanged>(_onEndDateChanged);
    on<BudgetFormNameChanged>(_onNameChanged);
    on<BudgetFormReset>(_onReset);
  }

  void _onTypeChanged(
    BudgetFormTypeChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    final now = DateTime.now();
    DateTime newStartDate;
    DateTime newEndDate;

    switch (event.type) {
      case BudgetType.monthly:
        newStartDate = DateTime(now.year, now.month, 1);
        newEndDate = DateTime(now.year, now.month + 1, 0);
        break;
      case BudgetType.project:
        newStartDate = now;
        newEndDate = DateTime(now.year, now.month + 3, now.day);
        break;
      case BudgetType.custom:
        newStartDate = now;
        newEndDate = DateTime(now.year, now.month, now.day + 30);
        break;
    }

    emit(
      state.copyWith(
        selectedType: event.type,
        startDate: newStartDate,
        endDate: newEndDate,
        clearCategory: true,
      ),
    );
  }

  void _onCategorySelected(
    BudgetFormCategorySelected event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(
      state.copyWith(selectedCategory: event.category, name: event.category),
    );
  }

  void _onColorChanged(
    BudgetFormColorChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(selectedColor: event.color));
  }

  void _onIconChanged(
    BudgetFormIconChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(selectedIcon: event.icon));
  }

  void _onStartDateChanged(
    BudgetFormStartDateChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    DateTime newEndDate = state.endDate;
    if (state.endDate.isBefore(event.date)) {
      newEndDate = event.date.add(const Duration(days: 30));
    }
    emit(state.copyWith(startDate: event.date, endDate: newEndDate));
  }

  void _onEndDateChanged(
    BudgetFormEndDateChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(endDate: event.date));
  }

  void _onNameChanged(
    BudgetFormNameChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onReset(BudgetFormReset event, Emitter<BudgetFormState> emit) {
    emit(BudgetFormState.initial());
  }
}
