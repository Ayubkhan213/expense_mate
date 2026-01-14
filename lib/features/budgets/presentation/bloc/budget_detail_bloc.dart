import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/get_transactions_by_budget_usecase.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_state.dart';

class BudgetDetailsBloc extends Bloc<BudgetDetailsEvent, BudgetDetailsState> {
  final GetTransactionsByBudgetUseCase getTransactionsByBudgetUseCase;

  BudgetDetailsBloc({required this.getTransactionsByBudgetUseCase})
    : super(BudgetDetailsState.initial()) {
    on<LoadBudgetDetailsEvent>(_onLoadBudgetDetails);
    on<RefreshBudgetDetailsEvent>(_onRefreshBudgetDetails);
    on<FilterBudgetTransactionsEvent>(_onFilterTransactions);
  }

  Future<void> _onLoadBudgetDetails(
    LoadBudgetDetailsEvent event,
    Emitter<BudgetDetailsState> emit,
  ) async {
    emit(state.copyWith(status: BudgetDetailsStatus.loading, clearError: true));

    try {
      final transactions = await getTransactionsByBudgetUseCase(event.budgetId);

      emit(
        state.copyWith(
          status: BudgetDetailsStatus.success,
          transactions: transactions,
          filteredTransactions: transactions,
          selectedFilter: TransactionFilter.all,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BudgetDetailsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshBudgetDetails(
    RefreshBudgetDetailsEvent event,
    Emitter<BudgetDetailsState> emit,
  ) async {
    add(LoadBudgetDetailsEvent(event.budgetId));
  }

  void _onFilterTransactions(
    FilterBudgetTransactionsEvent event,
    Emitter<BudgetDetailsState> emit,
  ) {
    final now = DateTime.now();
    List<TransactionModel> filtered;

    switch (event.filter) {
      case TransactionFilter.all:
        filtered = state.transactions;
        break;

      case TransactionFilter.thisWeek:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        filtered = state.transactions.where((t) {
          return t.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
              t.date.isBefore(weekEnd.add(const Duration(days: 1)));
        }).toList();
        break;

      case TransactionFilter.thisMonth:
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 0);
        filtered = state.transactions.where((t) {
          return t.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
              t.date.isBefore(monthEnd.add(const Duration(days: 1)));
        }).toList();
        break;

      case TransactionFilter.custom:
        // You can implement custom date range picker here
        filtered = state.transactions;
        break;
    }

    emit(
      state.copyWith(
        filteredTransactions: filtered,
        selectedFilter: event.filter,
      ),
    );
  }
}
