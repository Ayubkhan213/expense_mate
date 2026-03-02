import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';

abstract class HomeRepository {
  List<DebtPaymentModel> getPaymentsByDebtId(String debtId);
  List<DebtModel> getAllDebts();
  List<TransactionModel> getPureTransactions({int? limit});
  double getTotalIncome({DateTime? startDate, DateTime? endDate});
  double getTotalExpense({DateTime? startDate, DateTime? endDate});
  List<DebtModel> getActiveDebts();
  double getTotalBorrowed();
  double getTotalLent();

  // ─────────────────────────────────────────
  // FILE: All transcation Face
  // ─────────────────────────────────────────

  /// Returns only pure transactions (isDebt=false, isRecurring=false, isDeleted=false)
  List<TransactionModel> getAllPureTransactions();

  /// Filter by type (income/expense)
  List<TransactionModel> getByType(TransactionType type);

  /// Filter by date range
  List<TransactionModel> getByDateRange(DateTime start, DateTime end);

  /// Filter by payment method
  List<TransactionModel> getByPaymentMethod(PaymentMethod method);

  /// Search by category key or tag
  List<TransactionModel> search(String query);

  //================================
  //All debt
  //================================
  /// All transactions where isDebt == true, sorted newest first
  List<TransactionModel> getAllDebtTransactions();

  /// Get the DebtModel linked to a transaction via transaction.debtId
  DebtModel? getLinkedDebt(String debtId);
}
