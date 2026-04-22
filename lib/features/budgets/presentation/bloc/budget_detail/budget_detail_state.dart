import 'package:equatable/equatable.dart';
import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_event.dart';

enum BudgetDetailsStatus { initial, loading, success, error }

class BudgetDetailsState extends Equatable {
  final BudgetDetailsStatus status;
  final BudgetModel? budget;
  final List<TransactionModel> transactions;
  final List<TransactionModel> filteredTransactions;
  final TransactionFilter selectedFilter;
  final double totalSpent;
  final double remainingAmount;
  final double progressPercentage;
  final String? errorMessage;

  const BudgetDetailsState({
    required this.status,
    this.budget,
    required this.transactions,
    required this.filteredTransactions,
    required this.selectedFilter,
    required this.totalSpent,
    required this.remainingAmount,
    required this.progressPercentage,
    this.errorMessage,
  });

  factory BudgetDetailsState.initial() {
    return const BudgetDetailsState(
      status: BudgetDetailsStatus.initial,
      budget: null,
      transactions: [],
      filteredTransactions: [],
      selectedFilter: TransactionFilter.all,
      totalSpent: 0.0,
      remainingAmount: 0.0,
      progressPercentage: 0.0,
      errorMessage: null,
    );
  }

  BudgetDetailsState copyWith({
    BudgetDetailsStatus? status,
    BudgetModel? budget,
    List<TransactionModel>? transactions,
    List<TransactionModel>? filteredTransactions,
    TransactionFilter? selectedFilter,
    double? totalSpent,
    double? remainingAmount,
    double? progressPercentage,
    String? errorMessage,
    bool clearError = false,
    bool clearTransactions = false, // ✅ force reload flag
  }) {
    return BudgetDetailsState(
      status: status ?? this.status,
      budget: budget ?? this.budget,
      transactions: clearTransactions
          ? []
          : (transactions ?? this.transactions),
      filteredTransactions: clearTransactions
          ? []
          : (filteredTransactions ?? this.filteredTransactions),
      selectedFilter: selectedFilter ?? this.selectedFilter,
      totalSpent: clearTransactions ? 0.0 : (totalSpent ?? this.totalSpent),
      remainingAmount: clearTransactions
          ? 0.0
          : (remainingAmount ?? this.remainingAmount),
      progressPercentage: clearTransactions
          ? 0.0
          : (progressPercentage ?? this.progressPercentage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    budget,
    transactions,
    filteredTransactions,
    selectedFilter,
    totalSpent,
    remainingAmount,
    progressPercentage,
    errorMessage,
  ];
}
