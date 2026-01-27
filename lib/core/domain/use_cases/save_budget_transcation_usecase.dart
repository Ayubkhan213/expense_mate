import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

class SaveBudgetTranscationUsecase {
  final TransactionRepository transactionRepository;

  SaveBudgetTranscationUsecase({required this.transactionRepository});

  Future<TransactionResult> call({
    required TransactionModel transaction,
    required BudgetModel budget,
  }) async {
    return transactionRepository.saveBudgetTransactionUseCase(
      transaction: transaction,
      budget: budget,
    );
  }
}
