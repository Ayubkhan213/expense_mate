import 'package:equatable/equatable.dart';

abstract class BudgetDetailsEvent extends Equatable {
  const BudgetDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgetDetailsEvent extends BudgetDetailsEvent {
  final String budgetId;

  const LoadBudgetDetailsEvent(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

class RefreshBudgetDetailsEvent extends BudgetDetailsEvent {
  final String budgetId;

  const RefreshBudgetDetailsEvent(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

class FilterBudgetTransactionsEvent extends BudgetDetailsEvent {
  final TransactionFilter filter;

  const FilterBudgetTransactionsEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

enum TransactionFilter { all, thisWeek, thisMonth, custom }
