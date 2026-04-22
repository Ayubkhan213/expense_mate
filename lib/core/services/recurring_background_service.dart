// import 'package:spendio/core/data/models/category_hive_model.dart';
// import 'package:spendio/core/data/models/enums.dart';
// import 'package:spendio/core/data/models/recurring_transaction_model.dart';
// import 'package:spendio/core/data/models/transaction_item_model.dart';
// import 'package:spendio/core/data/models/transaction_model.dart';
// import 'package:spendio/core/services/hive_initializer.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:uuid/uuid.dart';
// import 'package:workmanager/workmanager.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print('🔥 BACKGROUND TASK STARTED at ${DateTime.now()}');
//     try {
//       await HiveInitializer.init();
//       print('✅ Hive initialized in background');

//       // ✅ Same function used everywhere — no duplication
//       await RecurringBackgroundService.processRecurringTransactions();
//       print('✅ Processing completed');

//       return Future.value(true);
//     } catch (e, stackTrace) {
//       print('❌ Background task error: $e');
//       print('Stack trace: $stackTrace');
//       return Future.value(false);
//     }
//   });
// }

// class RecurringBackgroundService {
//   // ✅ Public static — called from main.dart, callbackDispatcher, and debug buttons
//   static Future<void> processRecurringTransactions() async {
//     print('📋 Processing recurring transactions...');

//     // ✅ FIXED box names to match HiveBoxManager
//     final recurringBox = await Hive.openBox<RecurringTransactionModel>(
//       'recurring_transactions', // ← was 'recurringTransactions'
//     );
//     final transactionBox = await Hive.openBox<TransactionModel>('transactions');
//     final categoryBox = await Hive.openBox<CategoryHiveModel>('categories');

//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     final activeRecurring = recurringBox.values
//         .where((r) => r.isActive && !r.hasEnded)
//         .toList();

//     print('🔍 Found ${activeRecurring.length} active recurring');
//     print('📅 Today: $today');

//     for (final recurring in activeRecurring) {
//       print('');
//       print('Checking: ${recurring.categoryKey}');

//       int createdCount = 0;

//       while (true) {
//         final nextOccurrence = DateTime(
//           recurring.nextOccurrence.year,
//           recurring.nextOccurrence.month,
//           recurring.nextOccurrence.day,
//         );

//         print('  Next: $nextOccurrence');
//         print(
//           '  Due: ${nextOccurrence.isBefore(today) || nextOccurrence.isAtSameMomentAs(today)}',
//         );

//         // Stop if not yet due
//         if (!nextOccurrence.isBefore(today) &&
//             !nextOccurrence.isAtSameMomentAs(today)) {
//           break;
//         }

//         // Stop if end date passed
//         if (recurring.hasEnded) {
//           print('  ⏹ Recurring has ended, stopping.');
//           recurring.isActive = false;
//           await recurring.save();
//           break;
//         }

//         final transaction = _createTransaction(recurring, categoryBox);
//         await transactionBox.put(transaction.id, transaction);

//         recurring.generatedTransactionIds.add(transaction.id);
//         recurring.nextOccurrence = _calculateNextOccurrence(recurring);
//         await recurring.save();

//         createdCount++;
//         print('  ✅ CREATED ${transaction.id} for $nextOccurrence');
//         print('  📅 Next set to: ${recurring.nextOccurrence}');

//         // Safety cap — prevents infinite loop on bad data
//         if (createdCount >= 365) {
//           print('  ⚠️ Safety cap reached (365), stopping catch-up.');
//           break;
//         }
//       }

//       print('  📊 Total created for ${recurring.categoryKey}: $createdCount');
//     }

//     print('✅ Done. Transactions: ${transactionBox.length}');
//   }

//   static Future<void> initialize() async {
//     await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

//     // Backup check every 6 hours (in case app stays closed)
//     await Workmanager().registerPeriodicTask(
//       'recurring-processor',
//       'processRecurring',
//       frequency: const Duration(hours: 6),
//       initialDelay: const Duration(minutes: 1),
//       constraints: Constraints(
//         networkType: NetworkType.notRequired,
//         requiresBatteryNotLow: false,
//         requiresCharging: false,
//       ),
//     );

//     print('✅ WorkManager initialized - backup check every 6 hours');
//   }

//   static Future<void> cancelAll() async {
//     await Workmanager().cancelAll();
//   }
// }

// // ── Private helpers ──────────────────────────────────────────────────────────

// TransactionModel _createTransaction(
//   RecurringTransactionModel recurring,
//   Box<CategoryHiveModel> categoryBox,
// ) {
//   final category = categoryBox.values.firstWhere(
//     (c) => c.key == recurring.categoryKey,
//     orElse: () => CategoryHiveModel(
//       key: recurring.categoryKey,
//       iconCode: 0xe88a,
//       colorValue: 0xFF9C27B0,
//       isIncome: recurring.type == TransactionType.income,
//     ),
//   );

//   return TransactionModel(
//     id: const Uuid().v4(),
//     type: recurring.type,
//     items: [
//       TransactionItem(
//         category: category.key,
//         amount: recurring.amount,
//         note: recurring.note ?? '',
//       ),
//     ],
//     totalAmount: recurring.amount,
//     paymentMethod: recurring.paymentMethod,
//     date: DateTime.now(),
//     isRecurring: true,
//     tags: ['auto-generated'],
//   );
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
//       return _addMonths(current, 1, recurring.dayOfMonth);
//     case RecurrenceFrequency.quarterly:
//       return _addMonths(current, 3, recurring.dayOfMonth);
//     case RecurrenceFrequency.yearly:
//       return _addMonths(current, 12, recurring.dayOfMonth);
//   }
// }

// DateTime _addMonths(DateTime date, int months, int dayOfMonth) {
//   int newMonth = date.month + months;
//   int newYear = date.year;

//   while (newMonth > 12) {
//     newMonth -= 12;
//     newYear++;
//   }

//   final daysInMonth = DateTime(newYear, newMonth + 1, 0).day;
//   final validDay = dayOfMonth > daysInMonth ? daysInMonth : dayOfMonth;

//   return DateTime(newYear, newMonth, validDay);
// }
