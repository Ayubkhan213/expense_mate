import '../../data/models/recurring_transaction_model.dart';
import '../../data/models/enums.dart';

abstract class RecurringRepositories {
  // CREATE
  Future<String> createRecurring(RecurringTransactionModel recurring);

  // READ
  RecurringTransactionModel? getRecurringById(String id);

  List<RecurringTransactionModel> getAllRecurring();
  List<RecurringTransactionModel> getActiveRecurring();
  List<RecurringTransactionModel> getInactiveRecurring();
  List<RecurringTransactionModel> getDueRecurring();
  List<RecurringTransactionModel> getRecurringByType(TransactionType type);
  List<RecurringTransactionModel> getRecurringByFrequency(
    RecurrenceFrequency frequency,
  );

  // UPDATE
  Future<void> updateRecurring(RecurringTransactionModel recurring);

  // ACTIONS
  Future<void> markTransactionGenerated(
    String recurringId,
    String transactionId,
  );

  Future<void> updateNextOccurrence(String id, DateTime nextDate);
  Future<void> toggleActive(String id);

  // DELETE
  Future<void> deleteRecurring(String id);

  // STATISTICS
  int getActiveRecurringCount();
  double getTotalMonthlyRecurringIncome();
  double getTotalMonthlyRecurringExpense();
}
