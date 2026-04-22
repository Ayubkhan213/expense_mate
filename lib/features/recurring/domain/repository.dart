import 'package:spendio/core/data/models/recurring_transcation_sql_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';

abstract class RecurringRepository {
  Future<void> createRecurring(RecurringTransactionModel recurring);
  Future<void> updateRecurring(RecurringTransactionModel recurring);
  Future<void> deleteRecurring(String id);
  Future<List<RecurringTransactionModel>> getAllRecurring();
  Future<List<RecurringTransactionModel>> getActiveRecurring();
  Future<RecurringTransactionModel?> getRecurringById(String id);
  Future<List<RecurringTransactionModel>> getDueRecurring();
  Future<void> pauseRecurring(String id);
  Future<void> resumeRecurring(String id);
  Future<void> toggleActive(String id); // ← add
  Future<List<TransactionModel>> getGeneratedTransactions(
    List<String> ids,
  ); // ← already in impl, add here
}
