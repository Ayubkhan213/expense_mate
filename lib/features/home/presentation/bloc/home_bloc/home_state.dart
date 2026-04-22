import 'package:equatable/equatable.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';

enum HomeTab { transactions, debts }

class HomeState extends Equatable {
  final List<TransactionModel> transactions;
  final List<DebtModel> debts;
  final HomeTab selectedTab;
  final bool isLoading;
  final String? error;

  // Stats
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double totalDebtOwed;
  final double totalDebtLent;

  const HomeState({
    this.transactions = const [],
    this.debts = const [],
    this.selectedTab = HomeTab.transactions,
    this.isLoading = false,
    this.error,
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.totalDebtOwed = 0.0,
    this.totalDebtLent = 0.0,
  });

  HomeState copyWith({
    List<TransactionModel>? transactions,
    List<DebtModel>? debts,
    HomeTab? selectedTab,
    bool? isLoading,
    String? error,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    double? totalDebtOwed,
    double? totalDebtLent,
  }) {
    return HomeState(
      transactions: transactions ?? this.transactions,
      debts: debts ?? this.debts,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      totalDebtOwed: totalDebtOwed ?? this.totalDebtOwed,
      totalDebtLent: totalDebtLent ?? this.totalDebtLent,
    );
  }

  @override
  List<Object?> get props => [
    transactions,
    debts,
    selectedTab,
    isLoading,
    error,
    totalBalance,
    totalIncome,
    totalExpense,
    totalDebtOwed,
    totalDebtLent,
  ];
}
