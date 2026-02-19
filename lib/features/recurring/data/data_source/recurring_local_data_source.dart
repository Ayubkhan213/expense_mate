import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';

import 'package:expense_mate/core/services/hive_box_manager.dart';

import 'package:hive/hive.dart';

abstract class RecurringLocalDataSource {
  /// Create a new recurring transaction
  Future<void> createRecurring(RecurringTransactionModel recurring);

  Future<void> toggleActive(String id);

  /// Update existing recurring transaction
  Future<void> updateRecurring(RecurringTransactionModel recurring);

  /// Delete recurring transaction
  Future<void> deleteRecurring(String id);

  /// Get all recurring transactions
  Future<List<RecurringTransactionModel>> getAllRecurring();

  /// Get active recurring transactions
  Future<List<RecurringTransactionModel>> getActiveRecurring();

  /// Get recurring transaction by ID
  Future<RecurringTransactionModel?> getRecurringById(String id);

  /// Get due recurring transactions (nextOccurrence <= today)
  Future<List<RecurringTransactionModel>> getDueRecurring();
}

class RecurringLocalDataSourceImpl implements RecurringLocalDataSource {
  Box<RecurringTransactionModel> get _box => HiveBoxManager.recurring;
  Box<TransactionModel> get _transcationBox => HiveBoxManager.transactions;
  @override
  Future<void> toggleActive(String id) async {
    final recurring = _box.get(id);
    if (recurring != null) {
      recurring.isActive = !recurring.isActive;
      await recurring.save();
    }
  }

  @override
  Future<void> createRecurring(RecurringTransactionModel recurring) async {
    try {
      await _box.put(recurring.id, recurring);
    } catch (e, stackTrace) {
      print('CreateRecurring error: $e');
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateRecurring(RecurringTransactionModel recurring) async {
    try {
      await _box.put(recurring.id, recurring);
    } catch (e, stackTrace) {
      print('UpdateRecurring error: $e');
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteRecurring(String id) async {
    try {
      await _box.delete(id);
    } catch (e, stackTrace) {
      print('DeleteRecurring error: $e');
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getAllRecurring() async {
    try {
      return _box.values.toList();
    } catch (e, stackTrace) {
      print('GetAllRecurring error: $e');
      print(stackTrace);
      return [];
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getActiveRecurring() async {
    try {
      return _box.values.where((r) => r.isActive && !r.hasEnded).toList();
    } catch (e, stackTrace) {
      print('GetActiveRecurring error: $e');
      print(stackTrace);
      return [];
    }
  }

  @override
  Future<RecurringTransactionModel?> getRecurringById(String id) async {
    try {
      return _box.get(id);
    } catch (e, stackTrace) {
      print('GetRecurringById error: $e');
      print(stackTrace);
      return null;
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getDueRecurring() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      return _box.values.where((r) {
        if (!r.isActive || r.hasEnded) return false;

        final nextOccurrence = DateTime(
          r.nextOccurrence.year,
          r.nextOccurrence.month,
          r.nextOccurrence.day,
        );

        return nextOccurrence.isBefore(today) ||
            nextOccurrence.isAtSameMomentAs(today);
      }).toList();
    } catch (e, stackTrace) {
      print('GetDueRecurring error: $e');
      print(stackTrace);
      return [];
    }
  }
}
