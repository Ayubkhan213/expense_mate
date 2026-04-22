import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_from/budget_form_event.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetFormBloc extends Bloc<BudgetFormEvent, BudgetFormState> {
  BudgetFormBloc({
    Map<BudgetType, List<String>>? categoryPresets,
    BudgetModel? existingBudget, // ✅ NEW — for edit mode
  }) : super(
         BudgetFormState.initial(
           categoryPresets: categoryPresets,
           existingBudget: existingBudget, // ✅ pre-fill
         ),
       ) {
    on<BudgetFormTypeChanged>(_onTypeChanged);
    on<BudgetFormCategorySelected>(_onCategorySelected);
    on<BudgetFormColorChanged>(_onColorChanged);
    on<BudgetFormIconChanged>(_onIconChanged);
    on<BudgetFormStartDateChanged>(_onStartDateChanged);
    on<BudgetFormEndDateChanged>(_onEndDateChanged);
    on<BudgetFormNameChanged>(_onNameChanged);
    on<BudgetFormAmountChanged>(_onAmountChanged);
    on<BudgetFormOperationChanged>(_onOperationChanged);
    on<BudgetFormReset>(_onReset);
  }

  void _onTypeChanged(
    BudgetFormTypeChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    // Skip auto date change in edit mode
    if (state.isEditMode) {
      emit(state.copyWith(selectedType: event.type, clearCategory: true));
      return;
    }

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
      state.copyWith(
        selectedCategory: event.category,
        name: event.category,
        displayName: event.displayName,
      ),
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

  void _onAmountChanged(
    BudgetFormAmountChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    if (state.operation.isNotEmpty && event.amount.isNotEmpty) {
      final base = double.tryParse(state.amount) ?? 0;
      final incoming = double.tryParse(event.amount) ?? 0;
      final result = state.operation == '+' ? base + incoming : base - incoming;
      emit(
        state.copyWith(
          amount: result > 0
              ? result.toStringAsFixed(
                  result.truncateToDouble() == result ? 0 : 2,
                )
              : '',
          operation: '',
        ),
      );
    } else {
      emit(state.copyWith(amount: event.amount, operation: ''));
    }
  }

  void _onOperationChanged(
    BudgetFormOperationChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(operation: event.operation));
  }

  void _onReset(BudgetFormReset event, Emitter<BudgetFormState> emit) {
    emit(BudgetFormState.initial());
  }
}
