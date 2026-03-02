import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/features/recurring/domain/repository.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecurringListBloc extends Bloc<RecurringListEvent, RecurringListState> {
  final RecurringRepository repository;

  RecurringListBloc({required this.repository})
    : super(RecurringListInitial()) {
    on<LoadRecurringList>(_onLoad);
    on<FilterRecurringList>(_onFilter);
    on<ToggleRecurringStatus>(_onToggle);
    on<DeleteRecurring>(_onDelete);
    on<ProcessDueRecurring>(_onProcessDue);
    on<RecurringSearchOpened>(_onSearchOpened);
    on<RecurringSearchClosed>(_onSearchClosed);
    on<RecurringSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoad(
    LoadRecurringList event,
    Emitter<RecurringListState> emit,
  ) async {
    emit(RecurringListLoading());
    try {
      final all = await repository.getAllRecurring();
      final stats = _calculateStats(all);
      emit(
        RecurringListLoaded(
          all: all,
          filtered: all,
          currentFilter: RecurringFilterType.all,
          stats: stats,
        ),
      );
    } catch (e) {
      emit(RecurringListError(e.toString()));
    }
  }

  Future<void> _onFilter(
    FilterRecurringList event,
    Emitter<RecurringListState> emit,
  ) async {
    if (state is RecurringListLoaded) {
      final current = state as RecurringListLoaded;
      final filtered = _applyFilterAndSearch(
        current.all,
        event.filter,
        current.searchQuery,
      );
      emit(current.copyWith(filtered: filtered, currentFilter: event.filter));
    }
  }

  Future<void> _onToggle(
    ToggleRecurringStatus event,
    Emitter<RecurringListState> emit,
  ) async {
    try {
      final recurring = await repository.getRecurringById(event.id);
      if (recurring != null) {
        if (recurring.isActive) {
          await repository.pauseRecurring(event.id);
        } else {
          await repository.resumeRecurring(event.id);
        }
        emit(
          RecurringListOperationSuccess(
            recurring.isActive ? 'Paused' : 'Resumed',
          ),
        );
        add(LoadRecurringList());
      }
    } catch (e) {
      emit(RecurringListError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteRecurring event,
    Emitter<RecurringListState> emit,
  ) async {
    try {
      await repository.deleteRecurring(event.id);
      emit(RecurringListOperationSuccess('Deleted successfully'));
      add(LoadRecurringList());
    } catch (e) {
      emit(RecurringListError(e.toString()));
    }
  }

  Future<void> _onProcessDue(
    ProcessDueRecurring event,
    Emitter<RecurringListState> emit,
  ) async {
    try {
      emit(RecurringListOperationSuccess('Processed due transactions'));
      add(LoadRecurringList());
    } catch (e) {
      emit(RecurringListError(e.toString()));
    }
  }

  void _onSearchOpened(
    RecurringSearchOpened event,
    Emitter<RecurringListState> emit,
  ) {
    if (state is RecurringListLoaded) {
      emit((state as RecurringListLoaded).copyWith(searchOpen: true));
    }
  }

  void _onSearchClosed(
    RecurringSearchClosed event,
    Emitter<RecurringListState> emit,
  ) {
    if (state is RecurringListLoaded) {
      final current = state as RecurringListLoaded;
      emit(
        current.copyWith(
          searchOpen: false,
          searchQuery: '',
          filtered: _applyFilterAndSearch(
            current.all,
            current.currentFilter,
            '',
          ),
        ),
      );
    }
  }

  void _onSearchChanged(
    RecurringSearchChanged event,
    Emitter<RecurringListState> emit,
  ) {
    if (state is RecurringListLoaded) {
      final current = state as RecurringListLoaded;
      emit(
        current.copyWith(
          searchQuery: event.query,
          filtered: _applyFilterAndSearch(
            current.all,
            current.currentFilter,
            event.query,
          ),
        ),
      );
    }
  }

  // ── Filter + search combined ──
  List<RecurringTransactionModel> _applyFilterAndSearch(
    List<RecurringTransactionModel> all,
    RecurringFilterType filter,
    String query,
  ) {
    var result = _applyFilter(all, filter);
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where((r) => r.categoryKey.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  List<RecurringTransactionModel> _applyFilter(
    List<RecurringTransactionModel> all,
    RecurringFilterType filter,
  ) {
    switch (filter) {
      case RecurringFilterType.all:
        return all;
      case RecurringFilterType.active:
        return all.where((r) => r.isActive).toList();
      case RecurringFilterType.inactive:
        return all.where((r) => !r.isActive).toList();
      case RecurringFilterType.income:
        return all.where((r) => r.type == TransactionType.income).toList();
      case RecurringFilterType.expense:
        return all.where((r) => r.type == TransactionType.expense).toList();
      case RecurringFilterType.dueSoon:
        final nextWeek = DateTime.now().add(const Duration(days: 7));
        return all
            .where((r) => r.isActive && r.nextOccurrence.isBefore(nextWeek))
            .toList();
    }
  }

  RecurringStats _calculateStats(List<RecurringTransactionModel> all) {
    final active = all.where((r) => r.isActive).toList();
    final nextWeek = DateTime.now().add(const Duration(days: 7));
    final dueThisWeek = active
        .where((r) => r.nextOccurrence.isBefore(nextWeek))
        .length;
    double monthlyIncome = 0;
    double monthlyExpense = 0;
    for (final r in active) {
      final m = _convertToMonthly(r.amount, r.frequency);
      if (r.type == TransactionType.income) {
        monthlyIncome += m;
      } else {
        monthlyExpense += m;
      }
    }
    return RecurringStats(
      totalActive: active.length,
      totalInactive: all.length - active.length,
      dueThisWeek: dueThisWeek,
      monthlyIncomeEstimate: monthlyIncome,
      monthlyExpenseEstimate: monthlyExpense,
    );
  }

  double _convertToMonthly(double amount, RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return amount * 30;
      case RecurrenceFrequency.weekly:
        return amount * 4;
      case RecurrenceFrequency.biweekly:
        return amount * 2;
      case RecurrenceFrequency.monthly:
        return amount;
      case RecurrenceFrequency.quarterly:
        return amount / 3;
      case RecurrenceFrequency.yearly:
        return amount / 12;
    }
  }
}
