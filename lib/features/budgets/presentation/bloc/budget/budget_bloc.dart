// ==================== PRESENTATION LAYER ====================

// Budget Form Events (for bottom sheet UI state)

import 'package:expense_mate/core/app_export.dart';

import 'package:expense_mate/core/domain/use_cases/use_case.dart';

import 'package:expense_mate/features/budgets/domain/use_cases/create_budget_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/delete_budget_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/get_all_budgets_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/update_budget_usecase.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetAllBudgetsUseCase getAllBudgetsUseCase;
  final CreateBudgetUseCase createBudgetUseCase;
  final UpdateBudgetUseCase updateBudgetUseCase;
  final DeleteBudgetUseCase deleteBudgetUseCase;

  BudgetBloc({
    required this.getAllBudgetsUseCase,
    required this.createBudgetUseCase,
    required this.updateBudgetUseCase,
    required this.deleteBudgetUseCase,
  }) : super(BudgetState.initial()) {
    on<LoadBudgetsEvent>(_onLoadBudgets);
    on<CreateBudgetEvent>(_onCreateBudget);
    on<UpdateBudgetEvent>(_onUpdateBudget);
    on<DeleteBudgetEvent>(_onDeleteBudget);
    on<BudgetFilterChanged>(_onFilterChanged);
    on<BudgetSearchOpened>(_onSearchOpened);
    on<BudgetSearchClosed>(_onSearchClosed);
    on<BudgetSearchChanged>(_onSearchChanged);
  }

  void _onSearchOpened(BudgetSearchOpened event, Emitter<BudgetState> emit) {
    emit(state.copyWith(searchOpen: true));
  }

  void _onSearchClosed(BudgetSearchClosed event, Emitter<BudgetState> emit) {
    emit(state.copyWith(searchOpen: false, searchQuery: ''));
  }

  void _onSearchChanged(BudgetSearchChanged event, Emitter<BudgetState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onFilterChanged(BudgetFilterChanged event, Emitter<BudgetState> emit) {
    emit(state.copyWith(activeFilter: event.filter));
  }

  Future<void> _onLoadBudgets(
    LoadBudgetsEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading, clearError: true));

    final result = await getAllBudgetsUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BudgetStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (budgets) {
        final activeBudgets =
            budgets
                .where((b) => b.isActive && !b.isArchived && !b.isExpired)
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        final archivedBudgets =
            budgets.where((b) => b.isArchived || b.isExpired).toList()
              ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        emit(
          state.copyWith(
            status: BudgetStatus.success,
            budgets: budgets,
            activeBudgets: activeBudgets,
            archivedBudgets: archivedBudgets,
          ),
        );
      },
    );
  }

  Future<void> _onCreateBudget(
    CreateBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading, clearError: true));

    final params = CreateBudgetParams(
      name: event.name,
      type: event.type,
      totalAmount: event.totalAmount,
      startDate: event.startDate,
      endDate: event.endDate,
      category: event.category,
      icon: event.icon,
      colorCode: event.colorCode,
    );

    final result = await createBudgetUseCase(params);
    print(result);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BudgetStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (budget) {
        print('-------- Success -------------');
        add(LoadBudgetsEvent());
        emit(state.copyWith(successMessage: 'Budget created successfully'));
      },
    );
  }

  Future<void> _onUpdateBudget(
    UpdateBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading, clearError: true));

    final params = UpdateBudgetParams(
      budgetId: event.budgetId,
      name: event.name,
      totalAmount: event.totalAmount,
      isActive: event.isActive,
      isArchived: event.isArchived,
    );

    final result = await updateBudgetUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BudgetStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (budget) {
        add(LoadBudgetsEvent());
        emit(state.copyWith(successMessage: 'Budget updated successfully'));
      },
    );
  }

  Future<void> _onDeleteBudget(
    DeleteBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading, clearError: true));

    final result = await deleteBudgetUseCase(event.budgetId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BudgetStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        add(LoadBudgetsEvent());
        emit(state.copyWith(successMessage: 'Budget deleted successfully'));
      },
    );
  }
}
