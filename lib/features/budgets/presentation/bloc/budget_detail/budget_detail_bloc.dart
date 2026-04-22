import 'package:spendio/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/features/budgets/data/data_source/sql/budget_local_datasource.dart';
import 'package:spendio/features/budgets/domain/use_cases/get_budget_detail_usease.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_event.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetDetailsBloc extends Bloc<BudgetDetailsEvent, BudgetDetailsState> {
  final GetBudgetDetailsUseCase getBudgetDetailsUseCase;

  BudgetDetailsBloc({required this.getBudgetDetailsUseCase})
    : super(BudgetDetailsState.initial()) {
    on<LoadBudgetDetailsEvent>(_onLoadBudgetDetails);
    on<RefreshBudgetDetailsEvent>(_onRefreshBudgetDetails);
    on<FilterBudgetTransactionsEvent>(_onFilterTransactions);
    on<DeleteBudgetTransactionEvent>(_onDeleteTransaction);
  }

  Future<void> _onLoadBudgetDetails(
    LoadBudgetDetailsEvent event,
    Emitter<BudgetDetailsState> emit,
  ) async {
    final isFirstLoad = state.transactions.isEmpty;
    if (isFirstLoad) {
      emit(
        state.copyWith(status: BudgetDetailsStatus.loading, clearError: true),
      );
    }

    try {
      final data = await getBudgetDetailsUseCase(event.budgetId);

      // ✅ Calculate spent from actual transactions (not stored spent_amount)
      final transactions = data.transactions;
      final totalSpent = transactions.fold<double>(
        0.0,
        (sum, t) => sum + t.totalAmount,
      );
      final budget = data.budget;
      final totalBudget = budget?.totalAmount ?? 0.0;
      final remaining = totalBudget - totalSpent;
      final progress = totalBudget > 0
          ? (totalSpent / totalBudget).clamp(0.0, 1.0)
          : 0.0;

      emit(
        state.copyWith(
          status: BudgetDetailsStatus.success,
          budget: budget,
          transactions: transactions,
          filteredTransactions: transactions,
          totalSpent: totalSpent, // ✅ calculated from txns
          remainingAmount: remaining, // ✅ calculated
          progressPercentage: progress, // ✅ calculated
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
    // ✅ Force full reload on refresh — reset transactions so loading shows
    emit(
      state.copyWith(
        status: BudgetDetailsStatus.loading,
        clearTransactions: true,
      ),
    );
    add(LoadBudgetDetailsEvent(event.budgetId));
  }

  Future<void> _onDeleteTransaction(
    DeleteBudgetTransactionEvent event,
    Emitter<BudgetDetailsState> emit,
  ) async {
    try {
      await TransactionLocalDataSourceImpl().deleteTransaction(
        event.transactionId,
      );
      await BudgetLocalDataSourceImpl().removeTransactionFromBudget(
        event.budgetId,
        event.transactionId,
        event.amount,
      );
      // ✅ Force reload after delete
      emit(state.copyWith(clearTransactions: true));
      add(LoadBudgetDetailsEvent(event.budgetId));
    } catch (e) {
      emit(
        state.copyWith(
          status: BudgetDetailsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
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
