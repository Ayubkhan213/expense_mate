import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_event.dart';

enum BudgetStatus { initial, loading, success, error }

class BudgetState extends Equatable {
  final List<BudgetModel> budgets;
  final List<BudgetModel> activeBudgets;
  final List<BudgetModel> archivedBudgets;
  final BudgetStatus status;
  final String? errorMessage;
  final String? successMessage;
  final BudgetFilter activeFilter;
  final bool searchOpen; // ← search bar visible?
  final String searchQuery; // ← current search text

  const BudgetState({
    this.budgets = const [],
    this.activeBudgets = const [],
    this.archivedBudgets = const [],
    this.status = BudgetStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.activeFilter = BudgetFilter.all, // ← default is ALL now
    this.searchOpen = false,
    this.searchQuery = '',
  });

  factory BudgetState.initial() => const BudgetState();

  List<BudgetModel> get expiredBudgets =>
      budgets.where((b) => b.isExpired && !b.isArchived).toList();

  /// Base list for the active tab filter
  List<BudgetModel> get _tabFiltered {
    switch (activeFilter) {
      case BudgetFilter.all:
        return budgets;
      case BudgetFilter.active:
        return activeBudgets;
      case BudgetFilter.expired:
        return expiredBudgets;
      case BudgetFilter.archived:
        return archivedBudgets;
    }
  }

  /// Final list — tab filter + search applied together
  List<BudgetModel> get filteredBudgets {
    if (searchQuery.isEmpty) return _tabFiltered;
    final q = searchQuery.toLowerCase();
    return _tabFiltered.where((b) => b.name.toLowerCase().contains(q)).toList();
  }

  BudgetState copyWith({
    List<BudgetModel>? budgets,
    List<BudgetModel>? activeBudgets,
    List<BudgetModel>? archivedBudgets,
    BudgetStatus? status,
    String? errorMessage,
    String? successMessage,
    BudgetFilter? activeFilter,
    bool? searchOpen,
    String? searchQuery,
    bool clearError = false,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      activeBudgets: activeBudgets ?? this.activeBudgets,
      archivedBudgets: archivedBudgets ?? this.archivedBudgets,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: successMessage ?? this.successMessage,
      activeFilter: activeFilter ?? this.activeFilter,
      searchOpen: searchOpen ?? this.searchOpen,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    budgets,
    activeBudgets,
    archivedBudgets,
    status,
    errorMessage,
    successMessage,
    activeFilter,
    searchOpen,
    searchQuery,
  ];
}
