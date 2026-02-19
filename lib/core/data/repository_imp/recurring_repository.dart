// import 'package:expense_mate/core/domain/repository/recurrin_repository.dart';
// import 'package:expense_mate/core/data/data_sources/local/recurring_local_data_source.dart';
// import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';

// class RecurringRepositoryImp extends RecurringRepositories {
//   final RecurringLocalDataSource localDataSource;

//   RecurringRepositoryImp({required this.localDataSource});

//   @override
//   Future<String> createRecurring(RecurringTransactionModel recurring) async {
//     return await localDataSource.createRecurring(recurring);
//   }

//   @override
//   RecurringTransactionModel? getRecurringById(String id) {
//     return localDataSource.getRecurringById(id);
//   }

//   @override
//   List<RecurringTransactionModel> getAllRecurring() {
//     return localDataSource.getAllRecurring()
//       ..sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
//   }

//   @override
//   List<RecurringTransactionModel> getActiveRecurring() {
//     return localDataSource.getActiveRecurring()
//       ..sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
//   }

//   @override
//   List<RecurringTransactionModel> getInactiveRecurring() {
//     return localDataSource.getInactiveRecurring()
//       ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//   }

//   @override
//   List<RecurringTransactionModel> getDueRecurring() {
//     return localDataSource.getDueRecurring()
//       ..sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
//   }

//   @override
//   List<RecurringTransactionModel> getRecurringByType(TransactionType type) {
//     return localDataSource.getRecurringByType(type)
//       ..sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
//   }

//   @override
//   List<RecurringTransactionModel> getRecurringByFrequency(
//     RecurrenceFrequency frequency,
//   ) {
//     return localDataSource.getRecurringByFrequency(frequency)
//       ..sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
//   }

//   @override
//   Future<void> updateRecurring(RecurringTransactionModel recurring) async {
//     await localDataSource.updateRecurring(recurring);
//   }

//   @override
//   Future<void> markTransactionGenerated(
//     String recurringId,
//     String transactionId,
//   ) async {
//     await localDataSource.markTransactionGenerated(recurringId, transactionId);
//   }

//   @override
//   Future<void> updateNextOccurrence(String id, DateTime nextDate) async {
//     await localDataSource.updateNextOccurrence(id, nextDate);
//   }

  // @override
  // Future<void> toggleActive(String id) async {
  //   await localDataSource.toggleActive(id);
  // }

//   @override
//   Future<void> deleteRecurring(String id) async {
//     await localDataSource.deleteRecurring(id);
//   }

//   @override
//   int getActiveRecurringCount() {
//     return localDataSource.getActiveRecurring().length;
//   }

//   @override
//   double getTotalMonthlyRecurringIncome() {
//     return localDataSource
//         .getRecurringByType(TransactionType.income)
//         .where((r) => r.frequency == RecurrenceFrequency.monthly)
//         .fold(0.0, (sum, r) => sum + r.amount);
//   }

//   @override
//   double getTotalMonthlyRecurringExpense() {
//     return localDataSource
//         .getRecurringByType(TransactionType.expense)
//         .where((r) => r.frequency == RecurrenceFrequency.monthly)
//         .fold(0.0, (sum, r) => sum + r.amount);
//   }
// }
