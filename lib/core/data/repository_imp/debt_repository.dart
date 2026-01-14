import 'package:expense_mate/core/domain/repository/debt_repository.dart';
import 'package:expense_mate/core/data/data_sources/local/debt_local_data_source.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';

class DebtRepositoryImp extends DebtRepository {
  final DebtLocalDataSource localDataSource;

  DebtRepositoryImp({required this.localDataSource});

  @override
  Future<String> createDebt(DebtModel debt) async {
    return await localDataSource.createDebt(debt);
  }

  @override
  DebtModel? getDebtById(String id) {
    return localDataSource.getDebtById(id);
  }

  @override
  DebtModel? getDebtByTransactionId(String transactionId) {
    return localDataSource.getDebtByTransactionId(transactionId);
  }

  @override
  List<DebtModel> getAllDebts() {
    return localDataSource.getAllDebts()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  List<DebtModel> getActiveDebts() {
    return localDataSource.getActiveDebts()
      ..sort((a, b) => a.expectedReturnDate.compareTo(b.expectedReturnDate));
  }

  @override
  List<DebtModel> getSettledDebts() {
    return localDataSource.getSettledDebts()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  List<DebtModel> getDebtsByType(DebtType type) {
    return localDataSource.getDebtsByType(type)
      ..sort((a, b) => a.expectedReturnDate.compareTo(b.expectedReturnDate));
  }

  @override
  List<DebtModel> getOverdueDebts() {
    return localDataSource.getOverdueDebts()
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
  List<DebtPaymentModel> getPaymentsForDebt(String debtId) {
    return localDataSource.getPaymentsForDebt(debtId)
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  @override
  Future<void> deleteDebt(String id) async {
    await localDataSource.deleteDebt(id);
  }

  @override
  double getTotalBorrowed() {
    return localDataSource
        .getDebtsByType(DebtType.borrowed)
        .where((d) => !d.isReturned)
        .fold(0.0, (sum, d) => sum + d.remainingAmount);
  }

  @override
  double getTotalLent() {
    return localDataSource
        .getDebtsByType(DebtType.lent)
        .where((d) => !d.isReturned)
        .fold(0.0, (sum, d) => sum + d.remainingAmount);
  }

  @override
  double getTotalOverdue() {
    return localDataSource.getOverdueDebts().fold(
      0.0,
      (sum, d) => sum + d.remainingAmount,
    );
  }

  @override
  int getActiveDebtCount() {
    return localDataSource.getActiveDebts().length;
  }
}
