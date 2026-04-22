import 'package:spendio/core/data/models/debt_payment_sql_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';

abstract class HomeRepository {
  //================================
  // Debt
  //================================

  Future<List<DebtPaymentModel>> getPaymentsByDebtId(String debtId);

  Future<List<DebtModel>> getAllDebts();

  Future<List<DebtModel>> getActiveDebts();

  Future<double> getTotalBorrowed();

  Future<double> getTotalLent();
  Future<void> deleteTransaction(String transactionId);

  //================================
  // Dashboard Totals
  //================================

  Future<double> getTotalIncome({DateTime? startDate, DateTime? endDate});

  Future<double> getTotalExpense({DateTime? startDate, DateTime? endDate});

  //================================
  // Pure Transactions
  //================================

  /// Returns only pure transactions
  /// (isDebt=false, isRecurring=false, isDeleted=false)
  Future<List<TransactionModel>> getAllPureTransactions();

  /// Limited transactions for dashboard
  Future<List<TransactionModel>> getPureTransactions({int? limit});

  /// Filter by type (income/expense)
  Future<List<TransactionModel>> getByType(TransactionType type);

  /// Filter by date range
  Future<List<TransactionModel>> getByDateRange(DateTime start, DateTime end);

  /// Filter by payment method
  Future<List<TransactionModel>> getByPaymentMethod(PaymentMethod method);

  /// Search by category or tag
  Future<List<TransactionModel>> search(String query);

  //================================
  // Debt Transactions
  //================================

  /// All transactions where isDebt == true
  Future<List<TransactionModel>> getAllDebtTransactions();

  /// Get linked debt
  Future<DebtModel?> getLinkedDebt(String debtId);
  Future<void> deleteDebt(DebtModel debt);
  Future<void> updateDebt(DebtModel debt);
  Future<void> deleteDebtPayment(String paymentId);
}
