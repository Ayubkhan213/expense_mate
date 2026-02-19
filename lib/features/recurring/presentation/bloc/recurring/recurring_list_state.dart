// States
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';

abstract class RecurringListState {}

class RecurringListInitial extends RecurringListState {}

class RecurringListLoading extends RecurringListState {}

class RecurringListLoaded extends RecurringListState {
  final List<RecurringTransactionModel> all;
  final List<RecurringTransactionModel> filtered;
  final RecurringFilterType currentFilter;
  final RecurringStats stats;

  RecurringListLoaded({
    required this.all,
    required this.filtered,
    required this.currentFilter,
    required this.stats,
  });

  RecurringListLoaded copyWith({
    List<RecurringTransactionModel>? all,
    List<RecurringTransactionModel>? filtered,
    RecurringFilterType? currentFilter,
    RecurringStats? stats,
  }) {
    return RecurringListLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      currentFilter: currentFilter ?? this.currentFilter,
      stats: stats ?? this.stats,
    );
  }
}

class RecurringListError extends RecurringListState {
  final String message;
  RecurringListError(this.message);
}

class RecurringListOperationSuccess extends RecurringListState {
  final String message;
  RecurringListOperationSuccess(this.message);
}

// Stats Model
class RecurringStats {
  final int totalActive;
  final int totalInactive;
  final int dueThisWeek;
  final double monthlyIncomeEstimate;
  final double monthlyExpenseEstimate;

  RecurringStats({
    required this.totalActive,
    required this.totalInactive,
    required this.dueThisWeek,
    required this.monthlyIncomeEstimate,
    required this.monthlyExpenseEstimate,
  });

  double get netMonthly => monthlyIncomeEstimate - monthlyExpenseEstimate;
}

// Filter Type
enum RecurringFilterType { all, active, inactive, income, expense, dueSoon }
