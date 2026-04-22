import 'package:spendio/core/data/models/enums.dart';

abstract class AllDebtTransactionsEvent {}

class LoadAllDebtTransactions extends AllDebtTransactionsEvent {}

class RefreshAllDebtTransactions extends AllDebtTransactionsEvent {}

class SearchDebtTransactions extends AllDebtTransactionsEvent {
  final String query;
  SearchDebtTransactions(this.query);
}

/// null = all types
class FilterDebtTxByType extends AllDebtTransactionsEvent {
  final TransactionType? type;
  FilterDebtTxByType(this.type);
}

/// null = all methods
class FilterDebtTxByMethod extends AllDebtTransactionsEvent {
  final PaymentMethod? method;
  FilterDebtTxByMethod(this.method);
}

/// null dates = clear date filter
class FilterDebtTxByDateRange extends AllDebtTransactionsEvent {
  final DateTime? start;
  final DateTime? end;
  FilterDebtTxByDateRange({this.start, this.end});
}

class ClearDebtTxFilters extends AllDebtTransactionsEvent {}

class OpenDebtTxSearch extends AllDebtTransactionsEvent {}

class CloseDebtTxSearch extends AllDebtTransactionsEvent {}
