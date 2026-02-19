import 'package:equatable/equatable.dart';

abstract class RecurringDetailEvent extends Equatable {
  const RecurringDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecurringDetail extends RecurringDetailEvent {
  final String recurringId;

  const LoadRecurringDetail(this.recurringId);

  @override
  List<Object?> get props => [recurringId];
}

class RefreshRecurringDetail extends RecurringDetailEvent {
  final String recurringId;

  const RefreshRecurringDetail(this.recurringId);

  @override
  List<Object?> get props => [recurringId];
}
