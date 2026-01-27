import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

class SaveDebtTranscationUsecase {
  final TransactionRepository transactionRepository;

  SaveDebtTranscationUsecase({required this.transactionRepository});

  Future<TransactionResult> call({
    required TransactionModel transaction,
  }) async {
    return transactionRepository.saveNormalTransactionUseCase(
      transaction: transaction,
    );
  }
}
