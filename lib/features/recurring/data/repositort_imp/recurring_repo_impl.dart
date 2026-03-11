// ignore_for_file: avoid_print

import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';

import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart';
import 'package:expense_mate/features/recurring/domain/repository.dart';

class RecurringRepositoryImpl implements RecurringRepository {
  final RecurringLocalDataSource localDataSource;

  RecurringRepositoryImpl({required this.localDataSource});

  @override
  Future<void> createRecurring(RecurringTransactionModel recurring) async {
    try {
      await localDataSource.createRecurring(recurring);
    } catch (e) {
      print('Repository createRecurring error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateRecurring(RecurringTransactionModel recurring) async {
    try {
      await localDataSource.updateRecurring(recurring);
    } catch (e) {
      print('Repository updateRecurring error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteRecurring(String id) async {
    try {
      await localDataSource.deleteRecurring(id);
    } catch (e) {
      print('Repository deleteRecurring error: $e');
      rethrow;
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getAllRecurring() async {
    try {
      return await localDataSource.getAllRecurring();
    } catch (e) {
      print('Repository getAllRecurring error: $e');
      return [];
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getActiveRecurring() async {
    try {
      return await localDataSource.getActiveRecurring();
    } catch (e) {
      print('Repository getActiveRecurring error: $e');
      return [];
    }
  }

  @override
  Future<RecurringTransactionModel?> getRecurringById(String id) async {
    try {
      return await localDataSource.getRecurringById(id);
    } catch (e) {
      print('Repository getRecurringById error: $e');
      return null;
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getDueRecurring() async {
    try {
      return await localDataSource.getDueRecurring();
    } catch (e) {
      print('Repository getDueRecurring error: $e');
      return [];
    }
  }

  @override
  Future<void> pauseRecurring(String id) async {
    try {
      final recurring = await localDataSource.getRecurringById(id);
      if (recurring != null) {
        recurring.isActive = false;
        await localDataSource.updateRecurring(recurring);
      }
    } catch (e) {
      print('Repository pauseRecurring error: $e');
      rethrow;
    }
  }

  @override
  Future<void> resumeRecurring(String id) async {
    try {
      final recurring = await localDataSource.getRecurringById(id);
      if (recurring != null) {
        recurring.isActive = true;
        // Reset next occurrence if in past
        if (recurring.nextOccurrence.isBefore(DateTime.now())) {
          recurring.nextOccurrence = DateTime.now();
        }
        await localDataSource.updateRecurring(recurring);
      }
    } catch (e) {
      print('Repository resumeRecurring error: $e');
      rethrow;
    }
  }
}
