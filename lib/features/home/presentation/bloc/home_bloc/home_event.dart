import 'package:equatable/equatable.dart';
import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_state.dart';

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
