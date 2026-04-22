import 'package:spendio/core/data/data_sources/local/debt_local_datasource.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/features/home/data/data_source/home_data_source.dart';
import 'package:spendio/features/home/domain/repository/sql/home_repository.dart';

import '../../../../core/data/data_sources/local/transcation_local_data_source.dart';

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
  Future<List<DebtModel>> getActiveDebts() async {
    return await debtDataSource.getActiveDebts()
      ..sort((a, b) => a.expectedReturnDate.compareTo(b.expectedReturnDate));
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await localDataSource.deleteTransaction(transactionId);
  }

  @override
  Future<double> getTotalBorrowed() async {
    var debtData = await debtDataSource.getDebtsByType(DebtType.borrowed);

    double total = 0.0;
    for (var d in debtData.where((d) => !d.isReturned)) {
      total += await d.remainingAmount; // await if it's Future<double>
    }
    return total;
  }

  @override
  Future<double> getTotalLent() async {
    var debtData = await debtDataSource.getDebtsByType(DebtType.lent);

    double total = 0.0;
    for (var d in debtData.where((d) => !d.isReturned)) {
      total += await d.remainingAmount;
    }
    return total;
  }

  @override
  Future<double> getTotalIncome({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<TransactionModel> transactions;

    if (startDate != null && endDate != null) {
      var transaction = await localDataSource.getTransactionsByDateRange(
        startDate,
        endDate,
      );
      transactions = transaction
          .where((t) => t.type == TransactionType.income)
          .toList();
    } else {
      transactions = await localDataSource.getTransactionsByType(
        TransactionType.income,
      );
    }

    double total = 0.0;
    for (var t in transactions) {
      total += await t.totalAmount; // if totalAmount is Future<double>
    }
    return total;
  }

  @override
  Future<double> getTotalExpense({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<TransactionModel> transactions;

    if (startDate != null && endDate != null) {
      var transaction = await localDataSource.getTransactionsByDateRange(
        startDate,
        endDate,
      );
      transactions = transaction
          .where((t) => t.type == TransactionType.expense)
          .toList();
    } else {
      transactions = await localDataSource.getTransactionsByType(
        TransactionType.expense,
      );
    }

    double total = 0.0;
    for (var t in transactions) {
      total += await t.totalAmount; // if totalAmount is Future<double>
    }
    return total;
  }

  @override
  Future<List<TransactionModel>> getPureTransactions({int? limit}) async {
    final lists = await localDataSource.getAllTransactions();
    final list = lists.where((t) => !t.isDebt && !t.isRecurring).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (limit != null) {
      return list.take(limit).toList();
    }

    return list;
  }

  @override
  Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId) async {
    return homeDatasource.getPaymentsByDebtId(debtId);
  }

  @override
  Future<List<DebtModel>> getAllDebts() async {
    // You can sort by creation date if needed
    final debts = await homeDatasource.getAllDebts();
    debts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return debts;
  }

  //======================================
  //            All Transcation Face
  //=====================================
  /// Base: only pure transactions (no debt, no recurring, not deleted)
  Future<List<TransactionModel>> _pure() async {
    var trascations = await localDataSource.getAllTransactions();
    return trascations
        .where((t) => !t.isDebt && !t.isRecurring && !t.isDeleted)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getAllPureTransactions() => _pure();

  @override
  Future<List<TransactionModel>> getByType(TransactionType type) async {
    var pure = await _pure();
    return pure.where((t) => t.type == type).toList();
  }

  @override
  Future<List<TransactionModel>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    var pure = await _pure();
    return pure
        .where(
          (t) =>
              !t.date.isBefore(start) &&
              !t.date.isAfter(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  @override
  Future<List<TransactionModel>> getByPaymentMethod(
    PaymentMethod method,
  ) async {
    var pure = await _pure();

    return pure.where((t) => t.paymentMethod == method).toList();
  }

  @override
  Future<List<TransactionModel>> search(String query) async {
    final q = query.toLowerCase();
    var transcations = await _pure();
    return transcations.where((t) {
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
  Future<List<TransactionModel>> _base() async {
    var transcations = await localDataSource.getAllTransactions();
    return transcations.where((t) => t.isDebt && !t.isDeleted).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<TransactionModel>> getAllDebtTransactions() => _base();

  @override
  Future<DebtModel?> getLinkedDebt(String debtId) =>
      localDataSource.getDebtById(debtId);
  @override
  Future<void> deleteDebt(DebtModel debt) async {
    await homeDatasource.deleteDebtWithCascade(debt);
  }

  @override
  Future<void> updateDebt(DebtModel debt) async {
    await debtDataSource.updateDebt(debt);
  }

  @override
  Future<void> deleteDebtPayment(String paymentId) async {
    await debtDataSource.deletePayment(paymentId);
  }
}
