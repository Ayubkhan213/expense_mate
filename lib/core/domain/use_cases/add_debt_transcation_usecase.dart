import 'package:spendio/core/data/models/transcation_sql_model.dart';

import '../../data/models/transcation_result.dart';
import '../repository/sql/transcation_repository.dart';

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
