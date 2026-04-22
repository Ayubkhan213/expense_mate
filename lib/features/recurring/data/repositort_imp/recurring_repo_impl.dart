// ignore_for_file: avoid_print
import 'package:spendio/core/data/data_sources/local/transcation_local_data_source.dart';

import 'package:spendio/core/data/models/recurring_transcation_sql_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/features/recurring/data/data_source/recurring_local_datasource.dart';
import 'package:spendio/features/recurring/domain/repository.dart';

class RecurringRepositoryImpl implements RecurringRepository {
  final RecurringLocalDataSource localDataSource;
  final TransactionLocalDataSource transactionDataSource;

  RecurringRepositoryImpl({
    required this.localDataSource,
    required this.transactionDataSource,
  });

  @override
  Future<List<TransactionModel>> getGeneratedTransactions(
    List<String> ids,
  ) async {
    try {
      if (ids.isEmpty) return [];
      final all = await transactionDataSource.getAllTransactions();
      return all.where((t) => ids.contains(t.id)).toList();
    } catch (e) {
      print('Repository getGeneratedTransactions error: $e');
      return [];
    }
  }

  @override
  Future<void> toggleActive(String id) async {
    // ← add
    try {
      await localDataSource.toggleActive(id);
    } catch (e) {
      print('Repository toggleActive error: $e');
      rethrow;
    }
  }

  @override
  Future<void> pauseRecurring(String id) async {
    try {
      final recurring = await localDataSource.getRecurringById(id);
      if (recurring != null) {
        await localDataSource.updateRecurring(
          recurring.copyWith(isActive: false), // ← copyWith instead of mutation
        );
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
        await localDataSource.updateRecurring(
          recurring.copyWith(
            // ← copyWith instead of mutation
            isActive: true,
            nextOccurrence: recurring.nextOccurrence.isBefore(DateTime.now())
                ? DateTime.now()
                : recurring.nextOccurrence,
          ),
        );
      }
    } catch (e) {
      print('Repository resumeRecurring error: $e');
      rethrow;
    }
  }

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
}
