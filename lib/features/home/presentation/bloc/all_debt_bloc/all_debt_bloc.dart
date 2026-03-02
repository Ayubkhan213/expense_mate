import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/features/home/domain/repository/home_repository.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_debt_bloc/all_debt_event.dart';
import 'package:expense_mate/features/home/presentation/bloc/all_debt_bloc/all_debt_state.dart';
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
      final all = repository.getAllDebtTransactions();
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
  ) {
    final next = state.copyWith(searchQuery: e.query);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onFilterType(
    FilterDebtTxByType e,
    Emitter<AllDebtTransactionsState> emit,
  ) {
    final next = e.type == null
        ? state.copyWith(clearType: true)
        : state.copyWith(typeFilter: e.type);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onFilterMethod(
    FilterDebtTxByMethod e,
    Emitter<AllDebtTransactionsState> emit,
  ) {
    final next = e.method == null
        ? state.copyWith(clearMethod: true)
        : state.copyWith(methodFilter: e.method);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onFilterDate(
    FilterDebtTxByDateRange e,
    Emitter<AllDebtTransactionsState> emit,
  ) {
    final next = state.copyWith(
      dateStart: e.start,
      clearDateStart: e.start == null,
      dateEnd: e.end,
      clearDateEnd: e.end == null,
    );
    emit(next.copyWith(filtered: _applyFilters(next)));
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

  void _onCloseSearch(
    CloseDebtTxSearch e,
    Emitter<AllDebtTransactionsState> emit,
  ) {
    final next = state.copyWith(searchQuery: '', collapsedSearchOpen: false);
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  List<TransactionModel> _applyFilters(AllDebtTransactionsState s) {
    var result = List<TransactionModel>.from(s.all);

    if (s.searchQuery.isNotEmpty) {
      final q = s.searchQuery.toLowerCase();
      result = result.where((t) {
        final catMatch = t.items.any(
          (i) => i.category.toLowerCase().contains(q),
        );
        final tagMatch =
            t.tags?.any((tag) => tag.toLowerCase().contains(q)) ?? false;
        final debt = t.debtId != null
            ? repository.getLinkedDebt(t.debtId!)
            : null;
        final personMatch = (debt?.personName ?? '').toLowerCase().contains(q);
        return catMatch || tagMatch || personMatch;
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
