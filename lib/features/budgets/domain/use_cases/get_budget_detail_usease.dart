import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';

import '../../../../core/data/models/budget_detail_model.dart';

class GetBudgetDetailsUseCase {
  final BudgetRepository budgetRepository;

  GetBudgetDetailsUseCase(this.budgetRepository);

  Future<BudgetDetailsData> call(String budgetId) async {
    final budget = await budgetRepository.getBudgetById(budgetId);

    if (budget == null) {
      throw Exception('Budget not found');
    }

    final transactions = await budgetRepository.getTransactionsByBudget(
      budgetId,
    );

    return BudgetDetailsData(budget: budget, transactions: transactions);
  }
}
