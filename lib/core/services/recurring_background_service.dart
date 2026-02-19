import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_item_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/services/hive_initializer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('🔥 BACKGROUND TASK STARTED at ${DateTime.now()}');
    try {
      await HiveInitializer.init();
      print('✅ Hive initialized in background');

      await _processRecurringTransactions();
      print('✅ Processing completed');

      return Future.value(true);
    } catch (e, stackTrace) {
      print('❌ Background task error: $e');
      print('Stack trace: $stackTrace');
      return Future.value(false);
    }
  });
}

Future<void> _processRecurringTransactions() async {
  print('📋 Processing recurring transactions...');

  final recurringBox = await Hive.openBox<RecurringTransactionModel>(
    'recurringTransactions',
  );
  final transactionBox = await Hive.openBox<TransactionModel>('transactions');
  final categoryBox = await Hive.openBox<CategoryHiveModel>('categories');

  print('📦 Recurring count: ${recurringBox.length}');

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final activeRecurring = recurringBox.values
      .where((r) => r.isActive && !r.hasEnded)
      .toList();

  print('🔍 Found ${activeRecurring.length} active recurring');
  print('📅 Today: $today');

  for (final recurring in activeRecurring) {
    final nextOccurrence = DateTime(
      recurring.nextOccurrence.year,
      recurring.nextOccurrence.month,
      recurring.nextOccurrence.day,
    );

    print('');
    print('Checking: ${recurring.categoryKey}');
    print('  Next: $nextOccurrence');
    print(
      '  Due: ${nextOccurrence.isBefore(today) || nextOccurrence.isAtSameMomentAs(today)}',
    );

    if (nextOccurrence.isBefore(today) ||
        nextOccurrence.isAtSameMomentAs(today)) {
      final transaction = _createTransaction(recurring, categoryBox);
      await transactionBox.put(transaction.id, transaction);

      recurring.generatedTransactionIds.add(transaction.id);
      recurring.nextOccurrence = _calculateNextOccurrence(recurring);
      await recurring.save();

      print('  ✅ CREATED ${transaction.id}');
      print('  📅 Next: ${recurring.nextOccurrence}');
    }
  }

  print('✅ Done. Transactions: ${transactionBox.length}');
}

TransactionModel _createTransaction(
  RecurringTransactionModel recurring,
  Box<CategoryHiveModel> categoryBox,
) {
  final category = categoryBox.values.firstWhere(
    (c) => c.key == recurring.categoryKey,
    orElse: () => CategoryHiveModel(
      key: recurring.categoryKey,
      iconCode: 0xe88a,
      colorValue: 0xFF9C27B0,
      isIncome: recurring.type == TransactionType.income,
    ),
  );

  final uuid = const Uuid();

  return TransactionModel(
    id: uuid.v4(),
    type: recurring.type,
    items: [
      TransactionItem(
        category: category.key,
        amount: recurring.amount,
        note: recurring.note ?? '',
      ),
    ],
    totalAmount: recurring.amount,
    paymentMethod: recurring.paymentMethod,
    date: DateTime.now(),
    isRecurring: true,
    tags: ['auto-generated'],
  );
}

DateTime _calculateNextOccurrence(RecurringTransactionModel recurring) {
  final current = recurring.nextOccurrence;

  switch (recurring.frequency) {
    case RecurrenceFrequency.daily:
      return current.add(const Duration(days: 1));
    case RecurrenceFrequency.weekly:
      return current.add(const Duration(days: 7));
    case RecurrenceFrequency.biweekly:
      return current.add(const Duration(days: 14));
    case RecurrenceFrequency.monthly:
      return _addMonths(current, 1, recurring.dayOfMonth);
    case RecurrenceFrequency.quarterly:
      return _addMonths(current, 3, recurring.dayOfMonth);
    case RecurrenceFrequency.yearly:
      return _addMonths(current, 12, recurring.dayOfMonth);
  }
}

DateTime _addMonths(DateTime date, int months, int dayOfMonth) {
  int newMonth = date.month + months;
  int newYear = date.year;

  while (newMonth > 12) {
    newMonth -= 12;
    newYear++;
  }

  final daysInMonth = DateTime(newYear, newMonth + 1, 0).day;
  final validDay = dayOfMonth > daysInMonth ? daysInMonth : dayOfMonth;

  return DateTime(newYear, newMonth, validDay);
}

class RecurringBackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // Shows logs in debug
    );

    // Check every 6 hours (4 times per day)
    await Workmanager().registerPeriodicTask(
      'recurring-processor',
      'processRecurring',
      frequency: const Duration(hours: 6),
      initialDelay: const Duration(minutes: 1), // First check after 1 minute
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
    );

    print('✅ WorkManager initialized - will check every 6 hours');
  }

  static Future<void> processNow() async {
    await Workmanager().registerOneOffTask(
      'process-now-${DateTime.now().millisecondsSinceEpoch}',
      'processRecurring',
    );
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}
