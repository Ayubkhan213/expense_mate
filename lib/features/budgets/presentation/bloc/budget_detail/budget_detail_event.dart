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

// ✅ NEW — delete a transaction from this budget
class DeleteBudgetTransactionEvent extends BudgetDetailsEvent {
  final String transactionId;
  final String budgetId;
  final double amount; // needed to reverse spent_amount on budget
  const DeleteBudgetTransactionEvent({
    required this.transactionId,
    required this.budgetId,
    required this.amount,
  });
  @override
  List<Object?> get props => [transactionId];
}

enum TransactionFilter { all, thisWeek, thisMonth, custom }
