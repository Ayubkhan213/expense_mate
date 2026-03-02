// ─────────────────────────────────────────
// FILE: features/home/presentation/bloc/all_transactions/all_transactions_state.dart
// ─────────────────────────────────────────
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';

enum AllTransactionsStatus { initial, loading, loaded, error }

class AllTransactionsState {
  final AllTransactionsStatus status;
  final List<TransactionModel> all; // full unfiltered list
  final List<TransactionModel> filtered; // what the UI shows
  final String searchQuery;
  final TransactionType? typeFilter;
  final PaymentMethod? methodFilter;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final String? error;
  final bool collapsedSearchOpen;

  const AllTransactionsState({
    this.status = AllTransactionsStatus.initial,
    this.all = const [],
    this.filtered = const [],
    this.searchQuery = '',
    this.typeFilter,
    this.methodFilter,
    this.dateStart,
    this.dateEnd,
    this.error,
    this.collapsedSearchOpen = false,
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      typeFilter != null ||
      methodFilter != null ||
      dateStart != null ||
      dateEnd != null;

  AllTransactionsState copyWith({
    AllTransactionsStatus? status,
    List<TransactionModel>? all,
    List<TransactionModel>? filtered,
    String? searchQuery,
    TransactionType? typeFilter,
    bool clearType = false,
    PaymentMethod? methodFilter,
    bool clearMethod = false,
    DateTime? dateStart,
    bool clearDateStart = false,
    DateTime? dateEnd,
    bool clearDateEnd = false,
    String? error,
    bool? collapsedSearchOpen,
  }) {
    return AllTransactionsState(
      status: status ?? this.status,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: clearType ? null : (typeFilter ?? this.typeFilter),
      methodFilter: clearMethod ? null : (methodFilter ?? this.methodFilter),
      dateStart: clearDateStart ? null : (dateStart ?? this.dateStart),
      dateEnd: clearDateEnd ? null : (dateEnd ?? this.dateEnd),
      error: error ?? this.error,
      collapsedSearchOpen: collapsedSearchOpen ?? this.collapsedSearchOpen,
    );
  }
}
