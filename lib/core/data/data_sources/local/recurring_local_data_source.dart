// import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
// import 'package:expense_mate/core/data/models/enums.dart';
// import 'package:expense_mate/core/services/hive_box_manager.dart';
// import 'package:hive/hive.dart';

// abstract class RecurringLocalDataSource {
//   Future<String> createRecurring(RecurringTransactionModel recurring);
//   RecurringTransactionModel? getRecurringById(String id);
//   List<RecurringTransactionModel> getAllRecurring();
//   List<RecurringTransactionModel> getActiveRecurring();
//   List<RecurringTransactionModel> getInactiveRecurring();
//   List<RecurringTransactionModel> getDueRecurring();
//   List<RecurringTransactionModel> getRecurringByType(TransactionType type);
//   List<RecurringTransactionModel> getRecurringByFrequency(
//     RecurrenceFrequency frequency,
//   );
//   Future<void> updateRecurring(RecurringTransactionModel recurring);
//   Future<void> markTransactionGenerated(
//     String recurringId,
//     String transactionId,
//   );
//   Future<void> updateNextOccurrence(String id, DateTime nextDate);
//   Future<void> toggleActive(String id);
//   Future<void> deleteRecurring(String id);
// }

// class RecurringLocalDataSourceImpl implements RecurringLocalDataSource {
//   Box<RecurringTransactionModel> get _box => HiveBoxManager.recurring;

//   @override
//   Future<String> createRecurring(RecurringTransactionModel recurring) async {
//     print(recurring.id);

//     await _box.put(recurring.id, recurring);
//     return recurring.id;
//   }

//   @override
//   RecurringTransactionModel? getRecurringById(String id) {
//     return _box.get(id);
//   }

//   @override
//   List<RecurringTransactionModel> getAllRecurring() {
//     return _box.values.toList();
//   }

//   @override
//   List<RecurringTransactionModel> getActiveRecurring() {
//     return _box.values.where((r) => r.isActive && !r.hasEnded).toList();
//   }

//   @override
//   List<RecurringTransactionModel> getInactiveRecurring() {
//     return _box.values.where((r) => !r.isActive || r.hasEnded).toList();
//   }

//   @override
//   List<RecurringTransactionModel> getDueRecurring() {
//     return _box.values
//         .where((r) => r.isActive && r.isDue && !r.hasEnded)
//         .toList();
//   }

//   @override
//   List<RecurringTransactionModel> getRecurringByType(TransactionType type) {
//     return _box.values.where((r) => r.type == type && r.isActive).toList();
//   }

//   @override
//   List<RecurringTransactionModel> getRecurringByFrequency(
//     RecurrenceFrequency frequency,
//   ) {
//     return _box.values
//         .where((r) => r.frequency == frequency && r.isActive)
//         .toList();
//   }

//   @override
//   Future<void> updateRecurring(RecurringTransactionModel recurring) async {
//     await recurring.save();
//   }

//   @override
//   Future<void> markTransactionGenerated(
//     String recurringId,
//     String transactionId,
//   ) async {
//     final recurring = _box.get(recurringId);
//     if (recurring != null) {
//       recurring.generatedTransactionIds.add(transactionId);
//       await recurring.save();
//     }
//   }

//   @override
//   Future<void> updateNextOccurrence(String id, DateTime nextDate) async {
//     final recurring = _box.get(id);
//     if (recurring != null) {
//       recurring.nextOccurrence = nextDate;
//       await recurring.save();
//     }
//   }

  // @override
  // Future<void> toggleActive(String id) async {
  //   final recurring = _box.get(id);
  //   if (recurring != null) {
  //     recurring.isActive = !recurring.isActive;
  //     await recurring.save();
  //   }
  // }

//   @override
//   Future<void> deleteRecurring(String id) async {
//     await _box.delete(id);
//   }
// }
