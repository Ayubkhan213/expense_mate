import 'package:spendio/features/recurring/presentation/bloc/recurring/recurring_list_state.dart';

abstract class RecurringListEvent {}

class LoadRecurringList extends RecurringListEvent {}

class FilterRecurringList extends RecurringListEvent {
  final RecurringFilterType filter;
  FilterRecurringList(this.filter);
}

class ToggleRecurringStatus extends RecurringListEvent {
  final String id;
  ToggleRecurringStatus(this.id);
}

class DeleteRecurring extends RecurringListEvent {
  final String id;
  DeleteRecurring(this.id);
}

class ProcessDueRecurring extends RecurringListEvent {}

class RecurringSearchOpened extends RecurringListEvent {}

class RecurringSearchClosed extends RecurringListEvent {}

class RecurringSearchChanged extends RecurringListEvent {
  final String query;
  RecurringSearchChanged(this.query);
}
