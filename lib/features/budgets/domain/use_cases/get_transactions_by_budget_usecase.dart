import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';

class GetTransactionsByBudgetUseCase {
  final BudgetRepository repository;

  GetTransactionsByBudgetUseCase(this.repository);

  Future<List<TransactionModel>> call(String budgetId) async {
    return await repository.getTransactionsByBudget(budgetId);
  }
}
