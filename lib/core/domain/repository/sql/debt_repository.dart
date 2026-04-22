import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';

abstract class DebtRepository {
  // CREATE
  Future<String> createDebt(DebtModel debt);

  // READ
  Future<DebtModel?> getDebtById(String id);
  Future<DebtModel?> getDebtByTransactionId(String transactionId);

  Future<List<DebtModel>> getAllDebts();
  // List<DebtModel> getActiveDebts();
  Future<List<DebtModel>> getSettledDebts();
  Future<List<DebtModel>> getDebtsByType(DebtType type);
  Future<List<DebtModel>> getOverdueDebts();

  // UPDATE
  Future<void> updateDebt(DebtModel debt);

  // PAYMENTS
  Future<void> addPayment(DebtPaymentModel payment);
  Future<List<DebtPaymentModel>> getPaymentsForDebt(String debtId);

  // DELETE
  Future<void> deleteDebt(String id);

  // STATISTICS
  // double getTotalBorrowed();
  // double getTotalLent();
  Future<double> getTotalOverdue();
  Future<int> getActiveDebtCount();
}
