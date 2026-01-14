// budget_details_state.dart
import 'package:equatable/equatable.dart';

import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_event.dart';

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
  }) {
    return BudgetDetailsState(
      status: status ?? this.status,
      budget: budget ?? this.budget,
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      totalSpent: totalSpent ?? this.totalSpent,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      progressPercentage: progressPercentage ?? this.progressPercentage,
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
