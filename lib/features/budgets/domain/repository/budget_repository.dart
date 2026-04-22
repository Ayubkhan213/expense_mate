import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/error/failure.dart';
import 'package:spendio/core/utils/either.dart';

abstract class BudgetRepository {
  // ── CREATE ─────────────────────────────────────────────────────────────────
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget);

  // ── READ ───────────────────────────────────────────────────────────────────
  Future<Either<Failure, List<BudgetModel>>> getAllBudgets();
  Future<BudgetModel?> getBudgetById(String id);
  Future<List<BudgetModel>> getActiveBudgets();
  Future<List<BudgetModel>> getArchivedBudgets();
  Future<List<BudgetModel>> getBudgetsByType(BudgetType type);
  Future<List<BudgetModel>> getOverBudgets();
  Future<List<BudgetModel>> getExpiredBudgets();
  Future<List<TransactionModel>> getTransactionsByBudget(String budgetId);

  // ── UPDATE ─────────────────────────────────────────────────────────────────
  Future<Either<Failure, void>> updateBudget(BudgetModel budget);
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  );
  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  );
  Future<void> archiveBudget(String id);

  // ── DELETE ─────────────────────────────────────────────────────────────────
  Future<Either<Failure, void>> deleteBudget(String id);

  // ── STATISTICS ─────────────────────────────────────────────────────────────
  Future<double> getTotalBudgeted();
  Future<double> getTotalSpent();
  Future<double> getTotalRemaining();
  Future<int> getActiveBudgetCount();
}
