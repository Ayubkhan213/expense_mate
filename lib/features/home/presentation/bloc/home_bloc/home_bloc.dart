import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/features/home/domain/repository/sql/home_repository.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepo;

  HomeBloc({required HomeRepository homeRepo})
    : _homeRepo = homeRepo,
      super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<TabChanged>(_onTabChanged);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<DeleteDebt>(_onDeleteDebt);
  }

  // Handler:

  Future<void> _onDeleteDebt(DeleteDebt event, Emitter<HomeState> emit) async {
    try {
      await _homeRepo.deleteDebt(event.debt);
      add(LoadHomeData()); // silent reload
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    //  Only show full loading on very first load
    final isFirstLoad = state.transactions.isEmpty && state.debts.isEmpty;
    if (isFirstLoad) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = DateTime(now.year, now.month + 1, 0);

      final results = await Future.wait([
        _homeRepo.getPureTransactions(limit: 10),
        _homeRepo.getActiveDebts(),
        _homeRepo.getTotalIncome(startDate: startDate, endDate: endDate),
        _homeRepo.getTotalExpense(startDate: startDate, endDate: endDate),
        _homeRepo.getTotalBorrowed(),
        _homeRepo.getTotalLent(),
      ]);

      final transactions = results[0] as List<TransactionModel>;
      final debts = results[1] as List<DebtModel>;
      final totalIncome = results[2] as double;
      final totalExpense = results[3] as double;
      final totalDebtOwed = results[4] as double;
      final totalDebtLent = results[5] as double;
      final totalBalance =
          totalIncome - totalExpense - totalDebtOwed + totalDebtLent;

      emit(
        state.copyWith(
          transactions: transactions,
          debts: debts,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          totalDebtOwed: totalDebtOwed,
          totalDebtLent: totalDebtLent,
          totalBalance: totalBalance,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _homeRepo.deleteTransaction(event.transactionId);
      // Reload silently — no loading flash
      add(LoadHomeData());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onTabChanged(TabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    add(LoadHomeData());
  }
}
