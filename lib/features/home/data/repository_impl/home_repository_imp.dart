import 'package:expense_mate/core/data/data_sources/local/debt_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/features/home/data/data_source/home_datasource.dart';
import 'package:expense_mate/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImp extends HomeRepository {
  final HomeDatasource homeDatasource;
  final TransactionLocalDataSource localDataSource;
  final DebtLocalDataSource debtDataSource;
  HomeRepositoryImp({
    required this.homeDatasource,
    required this.localDataSource,
    required this.debtDataSource,
  });

  @override
  List<DebtModel> getActiveDebts() {
    return debtDataSource.getActiveDebts()
      ..sort((a, b) => a.expectedReturnDate.compareTo(b.expectedReturnDate));
  }

  @override
  double getTotalBorrowed() {
    return debtDataSource
        .getDebtsByType(DebtType.borrowed)
        .where((d) => !d.isReturned)
        .fold(0.0, (sum, d) => sum + d.remainingAmount);
  }

  @override
  double getTotalLent() {
    return debtDataSource
        .getDebtsByType(DebtType.lent)
        .where((d) => !d.isReturned)
        .fold(0.0, (sum, d) => sum + d.remainingAmount);
  }

  @override
  double getTotalIncome({DateTime? startDate, DateTime? endDate}) {
    List<TransactionModel> transactions;

    if (startDate != null && endDate != null) {
      transactions = localDataSource
          .getTransactionsByDateRange(startDate, endDate)
          .where((t) => t.type == TransactionType.income)
          .toList();
    } else {
      transactions = localDataSource.getTransactionsByType(
        TransactionType.income,
      );
    }

    return transactions.fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  @override
  double getTotalExpense({DateTime? startDate, DateTime? endDate}) {
    List<TransactionModel> transactions;

    if (startDate != null && endDate != null) {
      transactions = localDataSource
          .getTransactionsByDateRange(startDate, endDate)
          .where((t) => t.type == TransactionType.expense)
          .toList();
    } else {
      transactions = localDataSource.getTransactionsByType(
        TransactionType.expense,
      );
    }

    return transactions.fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  @override
  List<TransactionModel> getPureTransactions({int? limit}) {
    final list =
        localDataSource
            .getAllTransactions()
            .where((t) => !t.isDebt && !t.isRecurring)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    if (limit != null) {
      return list.take(limit).toList();
    }

    return list;
  }

  @override
  List<DebtPaymentModel> getPaymentsByDebtId(String debtId) {
    return homeDatasource.getPaymentsByDebtId(debtId);
  }

  @override
  List<DebtModel> getAllDebts() {
    // You can sort by creation date if needed
    final debts = homeDatasource.getAllDebts();
    debts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return debts;
  }

  //======================================
  //            All Transcation Face
  //=====================================
  /// Base: only pure transactions (no debt, no recurring, not deleted)
  List<TransactionModel> _pure() {
    return localDataSource
        .getAllTransactions()
        .where((t) => !t.isDebt && !t.isRecurring && !t.isDeleted)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<TransactionModel> getAllPureTransactions() => _pure();

  @override
  List<TransactionModel> getByType(TransactionType type) =>
      _pure().where((t) => t.type == type).toList();

  @override
  List<TransactionModel> getByDateRange(DateTime start, DateTime end) => _pure()
      .where(
        (t) =>
            !t.date.isBefore(start) &&
            !t.date.isAfter(end.add(const Duration(days: 1))),
      )
      .toList();

  @override
  List<TransactionModel> getByPaymentMethod(PaymentMethod method) =>
      _pure().where((t) => t.paymentMethod == method).toList();

  @override
  List<TransactionModel> search(String query) {
    final q = query.toLowerCase();
    return _pure().where((t) {
      final categoryMatch = t.items.any(
        (i) => i.category.toLowerCase().contains(q),
      );
      final tagMatch =
          t.tags?.any((tag) => tag.toLowerCase().contains(q)) ?? false;
      return categoryMatch || tagMatch;
    }).toList();
  }

  //================================
  //All debt
  //================================
  /// Base: only debt transactions, not deleted, newest first
  List<TransactionModel> _base() {
    return localDataSource
        .getAllTransactions()
        .where((t) => t.isDebt && !t.isDeleted)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<TransactionModel> getAllDebtTransactions() => _base();

  @override
  DebtModel? getLinkedDebt(String debtId) =>
      localDataSource.getDebtById(debtId);
}
