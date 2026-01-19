// // ============================================
// // 6. ADDITIONAL: PROCESS DUE RECURRING TRANSACTIONS
// // Path: lib/features/add_transaction/domain/usecases/process_due_recurring.dart
// // ============================================

// import 'package:expense_mate/core/data/models/enums.dart';
// import 'package:expense_mate/core/domain/repository/recurrin_repository.dart';
// import 'package:expense_mate/features/transcation/domain/use_cases/create_normal_transcation.dart';

// class ProcessDueRecurring {
//   final RecurringRepository recurringRepository;
//   // final CreateNormalTransaction createNormalTransaction;

//   ProcessDueRecurring({
//     required this.recurringRepository,
//     required this.createNormalTransaction,
//   });

//   Future<List<String>> execute() async {
//     final dueRecurring = recurringRepository.getDueRecurring();
//     final createdTransactionIds = <String>[];

//     for (var recurring in dueRecurring) {
//       try {
//         // Create transaction from recurring
//         final transactionId = await createNormalTransaction.execute(
//           type: recurring.type,
//           categoryKey: recurring.categoryKey,
//           amount: recurring.amount,
//           paymentMethod: recurring.paymentMethod,
//           date: recurring.nextOccurrence,
//           note: recurring.note,
//           tags: ['recurring', recurring.id],
//         );

//         createdTransactionIds.add(transactionId);

//         // Mark as generated
//         await recurringRepository.markTransactionGenerated(
//           recurring.id,
//           transactionId,
//         );

//         // Calculate next occurrence
//         final nextDate = _calculateNextOccurrence(recurring);
//         await recurringRepository.updateNextOccurrence(recurring.id, nextDate);
//       } catch (e) {
//         print('Error processing recurring transaction ${recurring.id}: $e');
//         // Continue with next recurring transaction
//         continue;
//       }
//     }

//     return createdTransactionIds;
//   }

//   DateTime _calculateNextOccurrence(recurring) {
//     final current = recurring.nextOccurrence;

//     switch (recurring.frequency) {
//       case RecurrenceFrequency.daily:
//         return current.add(const Duration(days: 1));
//       case RecurrenceFrequency.weekly:
//         return current.add(const Duration(days: 7));
//       case RecurrenceFrequency.biweekly:
//         return current.add(const Duration(days: 14));
//       case RecurrenceFrequency.monthly:
//         return DateTime(current.year, current.month + 1, current.day);
//       case RecurrenceFrequency.quarterly:
//         return DateTime(current.year, current.month + 3, current.day);
//       case RecurrenceFrequency.yearly:
//         return DateTime(current.year + 1, current.month, current.day);
//       default:
//         throw StateError('Unsupported recurrence frequency');
//     }
//   }
// }
