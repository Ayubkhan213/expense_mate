// import '../../data/models/debt_model.dart';
// import '../../data/models/debt_payment_model.dart';
// import '../../data/models/enums.dart';

// abstract class DebtRepository {
//   // CREATE
//   Future<String> createDebt(DebtModel debt);

//   // READ
//   DebtModel? getDebtById(String id);
//   DebtModel? getDebtByTransactionId(String transactionId);

//   List<DebtModel> getAllDebts();
//   // List<DebtModel> getActiveDebts();
//   List<DebtModel> getSettledDebts();
//   List<DebtModel> getDebtsByType(DebtType type);
//   List<DebtModel> getOverdueDebts();

//   // UPDATE
//   Future<void> updateDebt(DebtModel debt);

//   // PAYMENTS
//   Future<void> addPayment(DebtPaymentModel payment);
//   List<DebtPaymentModel> getPaymentsForDebt(String debtId);

//   // DELETE
//   Future<void> deleteDebt(String id);

//   // STATISTICS
//   // double getTotalBorrowed();
//   // double getTotalLent();
//   double getTotalOverdue();
//   int getActiveDebtCount();
// }
