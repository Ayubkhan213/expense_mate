import 'package:equatable/equatable.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_state.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {}

class TabChanged extends HomeEvent {
  final HomeTab tab;

  const TabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class RefreshHomeData extends HomeEvent {}

class DeleteTransaction extends HomeEvent {
  final String transactionId;
  const DeleteTransaction({required this.transactionId});
}

// Event:
class DeleteDebt extends HomeEvent {
  final DebtModel debt;
  const DeleteDebt({required this.debt});
}
