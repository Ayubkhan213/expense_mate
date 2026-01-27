// import 'package:expense_mate/core/data/models/transaction_model.dart';
// import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

// abstract class AddTransactionUseCase {
//   Future<void> call(TransactionModel transaction);
// }

// class AddTransactionUseCaseImpl implements AddTransactionUseCase {
//   final TransactionRepository transactionRepository;
//   final DebtRepository debtRepository;
//   final BudgetRepository budgetRepository;
//   final RecurringRepository recurringRepository;

//   AddTransactionUseCaseImpl({
//     required this.transactionRepository,
//     required this.debtRepository,
//     required this.budgetRepository,
//     required this.recurringRepository,
//   });

//   @override
//   Future<void> call(TransactionModel transaction) async {
//     // 1️ Always save transaction first
//     await transactionRepository.addTransaction(transaction);

//     // 2️ Handle Debt (Borrowed / Lent)
//     if (transaction.isDebt && transaction.debtId != null) {
//       await debtRepository.createDebtFromTransaction(transaction);
//     }

//     // 3️ Handle Budget
//     if (transaction.budgetId != null) {
//       await budgetRepository.applyTransaction(transaction);
//     }

//     // 4️ Handle Recurring (optional / future)
//     if (transaction.isRecurring) {
//       await recurringRepository.createFromTransaction(transaction);
//     }
//   }
// }

import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/repository/transcation_repository.dart';

class SaveNormalTranscationUsecase {
  final TransactionRepository transactionRepository;

  SaveNormalTranscationUsecase({required this.transactionRepository});

  Future<TransactionResult> call({
    required TransactionModel transaction,
  }) async {
    return transactionRepository.saveNormalTransactionUseCase(
      transaction: transaction,
    );
  }
}
