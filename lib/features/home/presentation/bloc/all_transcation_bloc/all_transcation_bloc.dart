// ─────────────────────────────────────────
// FILE: features/home/presentation/bloc/all_transactions/all_transactions_bloc.dart
// ─────────────────────────────────────────
import 'package:expense_mate/core/data/models/transaction_model.dart';

import 'package:expense_mate/features/home/domain/repository/home_repository.dart';

import 'package:expense_mate/features/home/presentation/bloc/all_transcation_bloc/all_transcation_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_transcation_bloc/all_transcation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTransactionsBloc
    extends Bloc<AllTransactionsEvent, AllTransactionsState> {
  final HomeRepository repository;

  AllTransactionsBloc({required this.repository})
    : super(const AllTransactionsState()) {
    on<LoadAllTransactions>(_onLoad);
    on<RefreshAllTransactions>(_onRefresh);
    on<SearchTransactions>(_onSearch);
    on<FilterByType>(_onFilterType);
    on<FilterByPaymentMethod>(_onFilterMethod);
    on<FilterByDateRange>(_onFilterDate);
    on<ClearFilters>(_onClear);
    on<OpenCollapsedSearch>(_onOpenSearch);
    on<CloseCollapsedSearch>(_onCloseSearch);
  }

  Future<void> _onLoad(
    LoadAllTransactions event,
    Emitter<AllTransactionsState> emit,
  ) async {
    emit(state.copyWith(status: AllTransactionsStatus.loading));
    try {
      final all = repository.getPureTransactions();
      emit(
        state.copyWith(
          status: AllTransactionsStatus.loaded,
          all: all,
          filtered: all,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AllTransactionsStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    RefreshAllTransactions event,
    Emitter<AllTransactionsState> emit,
  ) async {
    add(LoadAllTransactions());
  }

  void _onSearch(SearchTransactions event, Emitter<AllTransactionsState> emit) {
    final next = state.copyWith(searchQuery: event.query);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onFilterType(FilterByType event, Emitter<AllTransactionsState> emit) {
    final next = event.type == null
        ? state.copyWith(clearType: true)
        : state.copyWith(typeFilter: event.type);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onFilterMethod(
    FilterByPaymentMethod event,
    Emitter<AllTransactionsState> emit,
  ) {
    final next = event.method == null
        ? state.copyWith(clearMethod: true)
        : state.copyWith(methodFilter: event.method);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onFilterDate(
    FilterByDateRange event,
    Emitter<AllTransactionsState> emit,
  ) {
    final next = state.copyWith(
      dateStart: event.start,
      clearDateStart: event.start == null,
      dateEnd: event.end,
      clearDateEnd: event.end == null,
    );
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onClear(ClearFilters event, Emitter<AllTransactionsState> emit) {
    emit(
      AllTransactionsState(
        status: AllTransactionsStatus.loaded,
        all: state.all,
        filtered: state.all,
      ),
    );
  }

  void _onOpenSearch(
    OpenCollapsedSearch e,
    Emitter<AllTransactionsState> emit,
  ) {
    emit(state.copyWith(collapsedSearchOpen: true));
  }

  void _onCloseSearch(
    CloseCollapsedSearch e,
    Emitter<AllTransactionsState> emit,
  ) {
    final next = state.copyWith(searchQuery: '', collapsedSearchOpen: false);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  /// Applies all active filters on top of the full list
  List<TransactionModel> _applyFilters(AllTransactionsState s) {
    var result = List<TransactionModel>.from(s.all);

    if (s.searchQuery.isNotEmpty) {
      final q = s.searchQuery.toLowerCase();
      result = result.where((t) {
        final catMatch = t.items.any(
          (i) => i.category.toLowerCase().contains(q),
        );
        final tagMatch =
            t.tags?.any((tag) => tag.toLowerCase().contains(q)) ?? false;
        return catMatch || tagMatch;
      }).toList();
    }

    if (s.typeFilter != null) {
      result = result.where((t) => t.type == s.typeFilter).toList();
    }

    if (s.methodFilter != null) {
      result = result.where((t) => t.paymentMethod == s.methodFilter).toList();
    }

    if (s.dateStart != null) {
      result = result.where((t) => !t.date.isBefore(s.dateStart!)).toList();
    }

    if (s.dateEnd != null) {
      final end = s.dateEnd!.add(const Duration(days: 1));
      result = result.where((t) => t.date.isBefore(end)).toList();
    }

    return result;
  }
}
