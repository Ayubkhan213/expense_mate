import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/features/home/domain/repository/sql/home_repository.dart';
import 'package:spendio/features/home/presentation/bloc/all_debt_bloc/all_debt_event.dart';
import 'package:spendio/features/home/presentation/bloc/all_debt_bloc/all_debt_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllDebtTransactionsBloc
    extends Bloc<AllDebtTransactionsEvent, AllDebtTransactionsState> {
  final HomeRepository repository;

  AllDebtTransactionsBloc({required this.repository})
    : super(const AllDebtTransactionsState()) {
    on<LoadAllDebtTransactions>(_onLoad);
    on<RefreshAllDebtTransactions>(_onRefresh);
    on<SearchDebtTransactions>(_onSearch);
    on<FilterDebtTxByType>(_onFilterType);
    on<FilterDebtTxByMethod>(_onFilterMethod);
    on<FilterDebtTxByDateRange>(_onFilterDate);
    on<ClearDebtTxFilters>(_onClear);
    on<OpenDebtTxSearch>(_onOpenSearch);
    on<CloseDebtTxSearch>(_onCloseSearch);
  }

  Future<void> _onLoad(
    LoadAllDebtTransactions e,
    Emitter<AllDebtTransactionsState> emit,
  ) async {
    emit(state.copyWith(status: AllDebtTxStatus.loading));
    try {
      List<TransactionModel> all = await repository.getAllDebtTransactions();
      emit(
        state.copyWith(status: AllDebtTxStatus.loaded, all: all, filtered: all),
      );
    } catch (e) {
      emit(state.copyWith(status: AllDebtTxStatus.error, error: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshAllDebtTransactions e,
    Emitter<AllDebtTransactionsState> emit,
  ) async => add(LoadAllDebtTransactions());

  void _onSearch(
    SearchDebtTransactions e,
    Emitter<AllDebtTransactionsState> emit,
  ) async {
    final next = state.copyWith(searchQuery: e.query);
    final filtered = await _applyFilters(next);
    emit(next.copyWith(filtered: filtered));
  }

  void _onFilterType(
    FilterDebtTxByType e,
    Emitter<AllDebtTransactionsState> emit,
  ) async {
    final next = e.type == null
        ? state.copyWith(clearType: true)
        : state.copyWith(typeFilter: e.type);
    final filtered = await _applyFilters(next);
    emit(next.copyWith(filtered: filtered));
  }

  void _onFilterMethod(
    FilterDebtTxByMethod e,
    Emitter<AllDebtTransactionsState> emit,
  ) async {
    final next = e.method == null
        ? state.copyWith(clearMethod: true)
        : state.copyWith(methodFilter: e.method);
    final filtered = await _applyFilters(next);
    emit(next.copyWith(filtered: filtered));
  }

  void _onFilterDate(
    FilterDebtTxByDateRange e,
    Emitter<AllDebtTransactionsState> emit,
  ) async {
    final next = state.copyWith(
      dateStart: e.start,
      clearDateStart: e.start == null,
      dateEnd: e.end,
      clearDateEnd: e.end == null,
    );
    final filtered = await _applyFilters(next);
    emit(next.copyWith(filtered: filtered));
  }

  void _onClear(ClearDebtTxFilters e, Emitter<AllDebtTransactionsState> emit) {
    emit(
      AllDebtTransactionsState(
        status: AllDebtTxStatus.loaded,
        all: state.all,
        filtered: state.all,
      ),
    );
  }

  void _onOpenSearch(
    OpenDebtTxSearch e,
    Emitter<AllDebtTransactionsState> emit,
  ) {
    emit(state.copyWith(collapsedSearchOpen: true));
  }

  Future<void> _onCloseSearch(
    CloseDebtTxSearch e,
    Emitter<AllDebtTransactionsState> emit,
  ) async {
    final next = state.copyWith(searchQuery: '', collapsedSearchOpen: false);

    // Await the async filter
    final filtered = await _applyFilters(next);

    emit(next.copyWith(filtered: filtered));
  }

  Future<List<TransactionModel>> _applyFilters(
    AllDebtTransactionsState s,
  ) async {
    var result = List<TransactionModel>.from(s.all);

    if (s.searchQuery.isNotEmpty) {
      final q = s.searchQuery.toLowerCase();
      List<TransactionModel> filtered = [];

      for (var t in result) {
        final catMatch = t.items.any(
          (i) => i.category.toLowerCase().contains(q),
        );

        final tagMatch =
            t.tags?.any((tag) => tag.toLowerCase().contains(q)) ?? false;

        // Await the debt since getLinkedDebt returns a Future
        final debt = t.debtId != null
            ? await repository.getLinkedDebt(t.debtId!)
            : null;

        final personMatch = (debt?.personName ?? '').toLowerCase().contains(q);

        if (catMatch || tagMatch || personMatch) {
          filtered.add(t);
        }
      }

      result = filtered;
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
