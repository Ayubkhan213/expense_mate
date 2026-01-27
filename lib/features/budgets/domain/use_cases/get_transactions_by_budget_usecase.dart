import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/features/budgets/domain/repository/budget_repository.dart';

class GetTransactionsByBudgetUseCase {
  final BudgetRepository repository;

  GetTransactionsByBudgetUseCase(this.repository);

  Future<List<TransactionModel>> call(String budgetId) async {
    return await repository.getTransactionsByBudget(budgetId);
  }
}
