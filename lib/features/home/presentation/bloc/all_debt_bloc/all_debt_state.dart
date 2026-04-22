import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';

enum AllDebtTxStatus { initial, loading, loaded, error }

class AllDebtTransactionsState {
  final AllDebtTxStatus status;
  final List<TransactionModel> all;
  final List<TransactionModel> filtered;
  final String searchQuery;
  final TransactionType? typeFilter;
  final PaymentMethod? methodFilter;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final bool collapsedSearchOpen;
  final String? error;

  // ← NEW: resolved debt models keyed by debtId
  final Map<String, DebtModel> debtMap;

  const AllDebtTransactionsState({
    this.status = AllDebtTxStatus.initial,
    this.all = const [],
    this.filtered = const [],
    this.searchQuery = '',
    this.typeFilter,
    this.methodFilter,
    this.dateStart,
    this.dateEnd,
    this.collapsedSearchOpen = false,
    this.error,
    this.debtMap = const {},
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      typeFilter != null ||
      methodFilter != null ||
      dateStart != null;

  double get totalBorrowed => filtered
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (s, t) => s + t.totalAmount);

  double get totalLent => filtered
      .where((t) => t.type == TransactionType.income)
      .fold(0, (s, t) => s + t.totalAmount);

  AllDebtTransactionsState copyWith({
    AllDebtTxStatus? status,
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
    bool? collapsedSearchOpen,
    String? error,
    Map<String, DebtModel>? debtMap,
  }) {
    return AllDebtTransactionsState(
      status: status ?? this.status,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: clearType ? null : (typeFilter ?? this.typeFilter),
      methodFilter: clearMethod ? null : (methodFilter ?? this.methodFilter),
      dateStart: clearDateStart ? null : (dateStart ?? this.dateStart),
      dateEnd: clearDateEnd ? null : (dateEnd ?? this.dateEnd),
      collapsedSearchOpen: collapsedSearchOpen ?? this.collapsedSearchOpen,
      error: error ?? this.error,
      debtMap: debtMap ?? this.debtMap,
    );
  }
}
