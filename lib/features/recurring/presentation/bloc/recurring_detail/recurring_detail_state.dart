import 'package:equatable/equatable.dart';

import 'package:spendio/core/data/models/recurring_transcation_sql_model.dart';

import 'package:spendio/core/data/models/transcation_sql_model.dart';

abstract class RecurringDetailState extends Equatable {
  const RecurringDetailState();

  @override
  List<Object?> get props => [];
}

class RecurringDetailInitial extends RecurringDetailState {}

class RecurringDetailLoading extends RecurringDetailState {}

class RecurringDetailLoaded extends RecurringDetailState {
  final RecurringTransactionModel recurring;
  final List<TransactionModel> generatedTransactions;
  final double totalSpent;
  final double monthlyEstimate;

  const RecurringDetailLoaded({
    required this.recurring,
    required this.generatedTransactions,
    required this.totalSpent,
    required this.monthlyEstimate,
  });

  @override
  List<Object?> get props => [
    recurring,
    generatedTransactions,
    totalSpent,
    monthlyEstimate,
  ];
}

class RecurringDetailError extends RecurringDetailState {
  final String message;

  const RecurringDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
