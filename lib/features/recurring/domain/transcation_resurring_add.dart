import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';

abstract class RecurringRepository {
  Future<String> createRecurring(RecurringTransactionModel recurring);
  RecurringTransactionModel? getRecurringById(String id);
  List<RecurringTransactionModel> getAllRecurring();
  List<RecurringTransactionModel> getActiveRecurring();
  List<RecurringTransactionModel> getInactiveRecurring();
  List<RecurringTransactionModel> getDueRecurring();
  Future<void> updateRecurring(RecurringTransactionModel recurring);
  Future<void> toggleActive(String id);
  Future<void> deleteRecurring(String id);
}
