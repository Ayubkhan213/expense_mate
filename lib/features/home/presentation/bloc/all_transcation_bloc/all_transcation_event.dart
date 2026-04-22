// ─────────────────────────────────────────
// FILE: features/home/presentation/bloc/all_transactions/all_transactions_event.dart
// ─────────────────────────────────────────
import 'package:spendio/core/data/models/enums.dart';

abstract class AllTransactionsEvent {}

/// Initial load
class LoadAllTransactions extends AllTransactionsEvent {}

/// Refresh
class RefreshAllTransactions extends AllTransactionsEvent {}

/// Free-text search
class SearchTransactions extends AllTransactionsEvent {
  final String query;
  SearchTransactions(this.query);
}

/// Filter by type: null = all
class FilterByType extends AllTransactionsEvent {
  final TransactionType? type;
  FilterByType(this.type);
}

/// Filter by payment method: null = all
class FilterByPaymentMethod extends AllTransactionsEvent {
  final PaymentMethod? method;
  FilterByPaymentMethod(this.method);
}

/// Filter by date range: null = all time
class FilterByDateRange extends AllTransactionsEvent {
  final DateTime? start;
  final DateTime? end;
  FilterByDateRange({this.start, this.end});
}

/// Clear all active filters
class ClearFilters extends AllTransactionsEvent {}

/// Toggle collapsed search bar open/close
class OpenCollapsedSearch extends AllTransactionsEvent {}

class CloseCollapsedSearch extends AllTransactionsEvent {}
