import 'package:expense_mate/core/data/data_sources/local/recurring_local_data_source.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/domain/repository/recurrin_repository.dart';
import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart';
import 'package:expense_mate/features/recurring/domain/repository.dart';

// class RecurringRepositoryImple implements RecurringRepositories {
//   final RecurringLocalDataSource dataSource;

//   RecurringRepositoryImple({required this.dataSource});

//   @override
//   Future<String> createRecurring(RecurringTransactionModel recurring) {
//     return dataSource.createRecurring(recurring);
//   }

//   @override
//   RecurringTransactionModel? getRecurringById(String id) {
//     return dataSource.getRecurringById(id);
//   }

//   @override
//   List<RecurringTransactionModel> getAllRecurring() {
//     return dataSource.getAllRecurring();
//   }

//   @override
//   List<RecurringTransactionModel> getActiveRecurring() {
//     return dataSource.getActiveRecurring();
//   }

//   @override
//   List<RecurringTransactionModel> getInactiveRecurring() {
//     return dataSource.getInactiveRecurring();
//   }

//   @override
//   List<RecurringTransactionModel> getDueRecurring() {
//     return dataSource.getDueRecurring();
//   }

//   @override
//   Future<void> updateRecurring(RecurringTransactionModel recurring) {
//     return dataSource.updateRecurring(recurring);
//   }

//   @override
//   Future<void> toggleActive(String id) {
//     return dataSource.toggleActive(id);
//   }

//   @override
//   Future<void> deleteRecurring(String id) {
//     return dataSource.deleteRecurring(id);
//   }

//   @override
//   int getActiveRecurringCount() {
//     // TODO: implement getActiveRecurringCount
//     throw UnimplementedError();
//   }

//   @override
//   List<RecurringTransactionModel> getRecurringByFrequency(
//     RecurrenceFrequency frequency,
//   ) {
//     // TODO: implement getRecurringByFrequency
//     throw UnimplementedError();
//   }

//   @override
//   List<RecurringTransactionModel> getRecurringByType(TransactionType type) {
//     // TODO: implement getRecurringByType
//     throw UnimplementedError();
//   }

//   @override
//   double getTotalMonthlyRecurringExpense() {
//     // TODO: implement getTotalMonthlyRecurringExpense
//     throw UnimplementedError();
//   }

//   @override
//   double getTotalMonthlyRecurringIncome() {
//     // TODO: implement getTotalMonthlyRecurringIncome
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> markTransactionGenerated(
//     String recurringId,
//     String transactionId,
//   ) {
//     // TODO: implement markTransactionGenerated
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> updateNextOccurrence(String id, DateTime nextDate) {
//     // TODO: implement updateNextOccurrence
//     throw UnimplementedError();
//   }
// }

class RecurringRepositoryImpl implements RecurringRepository {
  final RecurringLocalDataSource localDataSource;

  RecurringRepositoryImpl({required this.localDataSource});

  @override
  Future<void> toggleActive(String id) async {
    await localDataSource.toggleActive(id);
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
