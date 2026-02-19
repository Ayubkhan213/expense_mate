import 'package:hive/hive.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_item_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:uuid/uuid.dart';

// class RecurringTransactionRepository {
// static const String _boxName = 'recurring_transactions';
// static const String _transactionBoxName = 'transactions';
// final _uuid = const Uuid();

// Future<Box<RecurringTransactionModel>> _getBox() async {
//   if (!Hive.isBoxOpen(_boxName)) {
//     return await Hive.openBox<RecurringTransactionModel>(_boxName);
//   }
//   return Hive.box<RecurringTransactionModel>(_boxName);
// }

// Future<Box<TransactionModel>> _getTransactionBox() async {
//   if (!Hive.isBoxOpen(_transactionBoxName)) {
//     return await Hive.openBox<TransactionModel>(_transactionBoxName);
//   }
//   return Hive.box<TransactionModel>(_transactionBoxName);
// }

// Future<List<RecurringTransactionModel>> getAllRecurringTransactions() async {
//   final box = await _getBox();
//   return box.values.toList();
// }

// Future<void> addRecurringTransaction(
//   RecurringTransactionModel transaction,
// ) async {
//   final box = await _getBox();
//   await box.put(transaction.id, transaction);
//   await transaction.save();
// }

// Future<void> updateRecurringTransaction(
//   RecurringTransactionModel transaction,
// ) async {
//   final box = await _getBox();
//   if (box.containsKey(transaction.id)) {
//     await transaction.save();
//   }
// }

// Future<void> deleteRecurringTransaction(String id) async {
//   final box = await _getBox();
//   final transaction = box.get(id);
//   if (transaction != null) {
//     await transaction.delete();
//   }
// }

// Future<void> toggleActive(String id) async {
//   final box = await _getBox();
//   final transaction = box.get(id);
//   if (transaction != null) {
//     transaction.isActive = !transaction.isActive;
//     await transaction.save();
//   }
// }

// Future<List<RecurringTransactionModel>> getDueTransactions() async {
//   final box = await _getBox();
//   final now = DateTime.now();
//   return box.values
//       .where((t) => t.isActive && t.nextOccurrence.isBefore(now))
//       .toList();
// }

// Future<void> processDueTransaction(
//   RecurringTransactionModel recurring,
// ) async {
//   // Create actual transaction
//   final transactionBox = await _getTransactionBox();

//   final transaction = TransactionModel(
//     id: _uuid.v4(),
//     type: recurring.type,
//     items: [
//       TransactionItem(
//         amount: recurring.amount,
//         note: recurring.note,
//         category: recurring.categoryKey,
//       ),
//     ],
//     totalAmount: recurring.amount,
//     paymentMethod: recurring.paymentMethod,
//     date: recurring.nextOccurrence,
//     isRecurring: true,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   );

//   await transactionBox.put(transaction.id, transaction);

//   // Update recurring transaction
//   recurring.generatedTransactionIds.add(transaction.id);
//   recurring.nextOccurrence = _calculateNextOccurrence(recurring);
//   await recurring.save();
// }

// DateTime _calculateNextOccurrence(RecurringTransactionModel recurring) {
//   final current = recurring.nextOccurrence;

//   switch (recurring.frequency) {
//     case RecurrenceFrequency.daily:
//       return current.add(const Duration(days: 1));

//     case RecurrenceFrequency.weekly:
//       return current.add(const Duration(days: 7));

//     case RecurrenceFrequency.biweekly:
//       return current.add(const Duration(days: 14));

//     case RecurrenceFrequency.monthly:
//       return DateTime(
//         current.year,
//         current.month + 1,
//         recurring.dayOfMonth.clamp(
//           1,
//           _daysInMonth(current.year, current.month + 1),
//         ),
//       );

//     case RecurrenceFrequency.quarterly:
//       return DateTime(
//         current.year,
//         current.month + 3,
//         recurring.dayOfMonth.clamp(
//           1,
//           _daysInMonth(current.year, current.month + 3),
//         ),
//       );

//     case RecurrenceFrequency.yearly:
//       return DateTime(
//         current.year + 1,
//         current.month,
//         recurring.dayOfMonth.clamp(
//           1,
//           _daysInMonth(current.year + 1, current.month),
//         ),
//       );
//   }
// }

// int _daysInMonth(int year, int month) {
//   if (month == 2) {
//     return _isLeapYear(year) ? 29 : 28;
//   }
//   if ([4, 6, 9, 11].contains(month)) {
//     return 30;
//   }
//   return 31;
// }

// bool _isLeapYear(int year) {
//   return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
// }
// }

abstract class RecurringRepository {
  // static const String _boxName = 'recurring_transactions';
  // static const String _transactionBoxName = 'transactions';
  // final _uuid = const Uuid();

  // Future<Box<RecurringTransactionModel>> _getBox() async {
  //   if (!Hive.isBoxOpen(_boxName)) {
  //     return await Hive.openBox<RecurringTransactionModel>(_boxName);
  //   }
  //   return Hive.box<RecurringTransactionModel>(_boxName);
  // }

  // Future<Box<TransactionModel>> _getTransactionBox() async {
  //   if (!Hive.isBoxOpen(_transactionBoxName)) {
  //     return await Hive.openBox<TransactionModel>(_transactionBoxName);
  //   }
  //   return Hive.box<TransactionModel>(_transactionBoxName);
  // }

  // Future<List<RecurringTransactionModel>> getAllRecurringTransactions() async {
  //   final box = await _getBox();
  //   return box.values.toList();
  // }

  // Future<void> addRecurringTransaction(
  //   RecurringTransactionModel transaction,
  // ) async {
  //   final box = await _getBox();
  //   await box.put(transaction.id, transaction);
  //   await transaction.save();
  // }

  // Future<void> updateRecurringTransaction(
  //   RecurringTransactionModel transaction,
  // ) async {
  //   final box = await _getBox();
  //   if (box.containsKey(transaction.id)) {
  //     await transaction.save();
  //   }
  // }

  // Future<void> deleteRecurringTransaction(String id) async {
  //   final box = await _getBox();
  //   final transaction = box.get(id);
  //   if (transaction != null) {
  //     await transaction.delete();
  //   }
  // }

  // Future<void> toggleActive(String id) async {
  //   final box = await _getBox();
  //   final transaction = box.get(id);
  //   if (transaction != null) {
  //     transaction.isActive = !transaction.isActive;
  //     await transaction.save();
  //   }
  // }

  // Future<List<RecurringTransactionModel>> getDueTransactions() async {
  //   final box = await _getBox();
  //   final now = DateTime.now();
  //   return box.values
  //       .where((t) => t.isActive && t.nextOccurrence.isBefore(now))
  //       .toList();
  // }

  // Future<void> processDueTransaction(
  //   RecurringTransactionModel recurring,
  // ) async {
  //   // Create actual transaction
  //   final transactionBox = await _getTransactionBox();

  //   final transaction = TransactionModel(
  //     id: _uuid.v4(),
  //     type: recurring.type,
  //     items: [
  //       TransactionItem(
  //         amount: recurring.amount,
  //         note: recurring.note,
  //         category: recurring.categoryKey,
  //       ),
  //     ],
  //     totalAmount: recurring.amount,
  //     paymentMethod: recurring.paymentMethod,
  //     date: recurring.nextOccurrence,
  //     isRecurring: true,
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //   );

  //   await transactionBox.put(transaction.id, transaction);

  //   // Update recurring transaction
  //   recurring.generatedTransactionIds.add(transaction.id);
  //   recurring.nextOccurrence = _calculateNextOccurrence(recurring);
  //   await recurring.save();
  // }

  // DateTime _calculateNextOccurrence(RecurringTransactionModel recurring) {
  //   final current = recurring.nextOccurrence;

  //   switch (recurring.frequency) {
  //     case RecurrenceFrequency.daily:
  //       return current.add(const Duration(days: 1));

  //     case RecurrenceFrequency.weekly:
  //       return current.add(const Duration(days: 7));

  //     case RecurrenceFrequency.biweekly:
  //       return current.add(const Duration(days: 14));

  //     case RecurrenceFrequency.monthly:
  //       return DateTime(
  //         current.year,
  //         current.month + 1,
  //         recurring.dayOfMonth.clamp(
  //           1,
  //           _daysInMonth(current.year, current.month + 1),
  //         ),
  //       );

  //     case RecurrenceFrequency.quarterly:
  //       return DateTime(
  //         current.year,
  //         current.month + 3,
  //         recurring.dayOfMonth.clamp(
  //           1,
  //           _daysInMonth(current.year, current.month + 3),
  //         ),
  //       );

  //     case RecurrenceFrequency.yearly:
  //       return DateTime(
  //         current.year + 1,
  //         current.month,
  //         recurring.dayOfMonth.clamp(
  //           1,
  //           _daysInMonth(current.year + 1, current.month),
  //         ),
  //       );
  //   }
  // }

  // int _daysInMonth(int year, int month) {
  //   if (month == 2) {
  //     return _isLeapYear(year) ? 29 : 28;
  //   }
  //   if ([4, 6, 9, 11].contains(month)) {
  //     return 30;
  //   }
  //   return 31;
  // }

  // bool _isLeapYear(int year) {
  //   return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  // }

  /// Create a new recurring transaction
  Future<void> createRecurring(RecurringTransactionModel recurring);

  /// Update existing recurring transaction
  Future<void> updateRecurring(RecurringTransactionModel recurring);

  /// Delete recurring transaction
  Future<void> deleteRecurring(String id);

  /// Get all recurring transactions
  Future<List<RecurringTransactionModel>> getAllRecurring();

  /// Get active recurring transactions only
  Future<List<RecurringTransactionModel>> getActiveRecurring();

  /// Get recurring transaction by ID
  Future<RecurringTransactionModel?> getRecurringById(String id);

  /// Get due recurring transactions
  Future<List<RecurringTransactionModel>> getDueRecurring();

  /// Pause recurring transaction
  Future<void> pauseRecurring(String id);

  /// Resume recurring transaction
  Future<void> resumeRecurring(String id);
}
