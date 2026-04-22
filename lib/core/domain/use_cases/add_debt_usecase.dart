import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/transcation_result.dart';

import '../repository/sql/transcation_repository.dart';

class AddDebtUsecase {
  final TransactionRepository transactionRepository;
  AddDebtUsecase({required this.transactionRepository});
  Future<TransactionResult> call({required DebtModel debt}) async {
    return transactionRepository.createDebt(debt);
  }
}
