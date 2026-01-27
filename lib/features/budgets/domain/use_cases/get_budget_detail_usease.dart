import 'package:expense_mate/core/data/models/budget_detail_model.dart';
import 'package:expense_mate/features/budgets/domain/repository/budget_repository.dart';

class GetBudgetDetailsUseCase {
  final BudgetRepository budgetRepository;

  GetBudgetDetailsUseCase(this.budgetRepository);

  BudgetDetailsData call(String budgetId) {
    final budget = budgetRepository.getBudgetById(budgetId);

    if (budget == null) {
      throw Exception('Budget not found');
    }

    final transactions = budgetRepository.getTransactionsByBudget(budgetId)
      ..sort((a, b) => b.date.compareTo(a.date));

    return BudgetDetailsData(budget: budget, transactions: transactions);
  }
}
