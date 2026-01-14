import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

class GetTransactionsByBudgetUseCase {
  final TransactionRepository repository;

  GetTransactionsByBudgetUseCase(this.repository);

  Future<List<TransactionModel>> call(String budgetId) async {
    return await repository.getTransactionsByBudget(budgetId);
  }
}
