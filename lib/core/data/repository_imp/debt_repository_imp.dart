import 'package:spendio/core/data/data_sources/local/debt_local_datasource.dart';
import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/domain/repository/sql/debt_repository.dart';

class DebtRepositoryImp extends DebtRepository {
  final DebtLocalDataSource localDataSource;

  DebtRepositoryImp({required this.localDataSource});

  @override
  Future<String> createDebt(DebtModel debt) async {
    return await localDataSource.createDebt(debt);
  }

  @override
  Future<DebtModel?> getDebtById(String id) {
    return localDataSource.getDebtById(id);
  }

  @override
  Future<DebtModel?> getDebtByTransactionId(String transactionId) {
    return localDataSource.getDebtByTransactionId(transactionId);
  }

  @override
  Future<List<DebtModel>> getAllDebts() async {
    return await localDataSource.getAllDebts()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // @override
  // List<DebtModel> getActiveDebts() {
  //   return localDataSource.getActiveDebts()
  //     ..sort((a, b) => a.expectedReturnDate.compareTo(b.expectedReturnDate));
  // }

  @override
  Future<List<DebtModel>> getSettledDebts() async {
    return await localDataSource.getSettledDebts()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<DebtModel>> getDebtsByType(DebtType type) async {
    return await localDataSource.getDebtsByType(type)
      ..sort((a, b) => a.expectedReturnDate.compareTo(b.expectedReturnDate));
  }

  @override
  Future<List<DebtModel>> getOverdueDebts() async {
    return await localDataSource.getOverdueDebts()
      ..sort((a, b) => a.expectedReturnDate.compareTo(b.expectedReturnDate));
  }

  @override
  Future<void> updateDebt(DebtModel debt) async {
    await localDataSource.updateDebt(debt);
  }

  @override
  Future<void> addPayment(DebtPaymentModel payment) async {
    await localDataSource.addPayment(payment);
  }

  @override
  Future<List<DebtPaymentModel>> getPaymentsForDebt(String debtId) async {
    return await localDataSource.getPaymentsForDebt(debtId)
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  @override
  Future<void> deleteDebt(String id) async {
    await localDataSource.deleteDebt(id);
  }

  // @override
  // double getTotalBorrowed() {
  //   return localDataSource
  //       .getDebtsByType(DebtType.borrowed)
  //       .where((d) => !d.isReturned)
  //       .fold(0.0, (sum, d) => sum + d.remainingAmount);
  // }

  // @override
  // double getTotalLent() {
  //   return localDataSource
  //       .getDebtsByType(DebtType.lent)
  //       .where((d) => !d.isReturned)
  //       .fold(0.0, (sum, d) => sum + d.remainingAmount);
  // }

  @override
  Future<double> getTotalOverdue() async {
    var debtData = await localDataSource.getOverdueDebts();

    double total = 0.0;

    for (var d in debtData) {
      total += d.remainingAmount;
    }

    return total;
  }

  @override
  Future<int> getActiveDebtCount() async {
    var debtData = await localDataSource.getActiveDebts();
    return debtData.length;
  }
}
