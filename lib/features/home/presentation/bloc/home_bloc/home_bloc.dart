import 'package:expense_mate/core/domain/repository/debt_repository.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';
import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TransactionRepository _transactionRepo;
  final DebtRepository _debtRepo;

  HomeBloc({
    required TransactionRepository transactionRepo,
    required DebtRepository debtRepo,
  }) : _transactionRepo = transactionRepo,
       _debtRepo = debtRepo,
       super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<TabChanged>(_onTabChanged);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Get current month date range
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = DateTime(now.year, now.month + 1, 0);

      // Load data
      final transactions = _transactionRepo.getPureTransactions(limit: 10);
      final debts = _debtRepo.getActiveDebts();

      // Calculate stats
      final totalIncome = _transactionRepo.getTotalIncome(
        startDate: startDate,
        endDate: endDate,
      );
      final totalExpense = _transactionRepo.getTotalExpense(
        startDate: startDate,
        endDate: endDate,
      );
      final totalDebtOwed = _debtRepo.getTotalBorrowed();
      final totalDebtLent = _debtRepo.getTotalLent();
      final totalBalance =
          totalIncome - totalExpense - totalDebtOwed + totalDebtLent;

      emit(
        state.copyWith(
          transactions: transactions,
          debts: debts,
          totalBalance: totalBalance,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          totalDebtOwed: totalDebtOwed,
          totalDebtLent: totalDebtLent,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
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
