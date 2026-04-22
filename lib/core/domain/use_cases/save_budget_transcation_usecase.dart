import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/domain/repository/sql/transcation_repository.dart';

import '../../data/models/transcation_result.dart';

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
