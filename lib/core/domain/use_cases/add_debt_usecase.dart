import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

class AddDebtUsecase {
  final TransactionRepository transactionRepository;
  AddDebtUsecase({required this.transactionRepository});
  Future<TransactionResult> call({required DebtModel debt}) async {
    return transactionRepository.createDebt(debt);
  }
}
