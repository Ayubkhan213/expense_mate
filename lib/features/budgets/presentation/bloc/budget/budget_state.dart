// Budget Status Enum
import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';

enum BudgetStatus { initial, loading, success, error }

// Main Budget State
class BudgetState extends Equatable {
  final BudgetStatus status;
  final List<BudgetModel> budgets;
  final List<BudgetModel> activeBudgets;
  final List<BudgetModel> archivedBudgets;
  final String? errorMessage;
  final String? successMessage;

  const BudgetState({
    this.status = BudgetStatus.initial,
    this.budgets = const [],
    this.activeBudgets = const [],
    this.archivedBudgets = const [],
    this.errorMessage,
    this.successMessage,
  });

  bool get isInitial => status == BudgetStatus.initial;
  bool get isLoading => status == BudgetStatus.loading;
  bool get isSuccess => status == BudgetStatus.success;
  bool get isError => status == BudgetStatus.error;
  bool get hasData => budgets.isNotEmpty;

  factory BudgetState.initial() => const BudgetState();

  BudgetState copyWith({
    BudgetStatus? status,
    List<BudgetModel>? budgets,
    List<BudgetModel>? activeBudgets,
    List<BudgetModel>? archivedBudgets,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return BudgetState(
      status: status ?? this.status,
      budgets: budgets ?? this.budgets,
      activeBudgets: activeBudgets ?? this.activeBudgets,
      archivedBudgets: archivedBudgets ?? this.archivedBudgets,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    budgets,
    activeBudgets,
    archivedBudgets,
    errorMessage,
    successMessage,
  ];
}
