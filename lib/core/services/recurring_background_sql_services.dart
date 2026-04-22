// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/recurring_transcation_sql_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/services/app_prefs.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import '../data/models/category_model.dart';
import '../data/models/transcation_item_sql_model.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('🔥 BACKGROUND TASK STARTED at ${DateTime.now()}');
    try {
      await AppPrefs.instance.init();
      await SqliteHelper.instance.database;
      print('✅ SQLite initialized in background');
      await RecurringBackgroundService.processRecurringTransactions();
      print('✅ Processing completed');
      return Future.value(true);
    } catch (e, stackTrace) {
      print('❌ Background task error: $e');
      print('Stack trace: $stackTrace');
      return Future.value(false);
    }
  });
}

class RecurringBackgroundService {
  static final SqliteHelper _db = SqliteHelper.instance;

  static String get _userId => AppPrefs.instance.userId ?? '';

  static Future<void> processRecurringTransactions() async {
    print('📋 Processing recurring transactions...');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayIso = today.toIso8601String();

    final recurringRows = await _db.queryWhere(
      DbConstants.tableRecurringTransactions,
      where:
          '${DbConstants.colIsActive} = 1 '
          'AND ${DbConstants.colUserId} = ? '
          'AND (${DbConstants.colRecurringEndDate} IS NULL '
          '     OR ${DbConstants.colRecurringEndDate} > ?)',
      whereArgs: [_userId, todayIso],
    );

    final activeRecurring = recurringRows
        .map((r) => RecurringTransactionModel.fromMap(r))
        .toList();

    print('🔍 Found ${activeRecurring.length} active recurring for $_userId');
    print('📅 Today: $today');

    final categoryRows = await _db.queryAll(DbConstants.tableCategories);
    final categories = categoryRows
        .map((r) => CategoryModel.fromMap(r))
        .toList();

    for (final recurring in activeRecurring) {
      print('');
      print('Checking: ${recurring.categoryKey}');

      int createdCount = 0;

      DateTime nextOccurrence = DateTime(
        recurring.nextOccurrence.year,
        recurring.nextOccurrence.month,
        recurring.nextOccurrence.day,
      );

      while (true) {
        print('  Next: $nextOccurrence');

        final isDue = !nextOccurrence.isAfter(today);
        print('  Due: $isDue');

        if (!isDue) break;

        // Check end date
        if (recurring.endDate != null &&
            nextOccurrence.isAfter(recurring.endDate!)) {
          print('  ⏹ Recurring has ended, deactivating.');
          await _db.update(
            DbConstants.tableRecurringTransactions,
            {
              DbConstants.colIsActive: 0,
              DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
            },
            where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
            whereArgs: [recurring.id, _userId],
          );
          break;
        }

        // Duplicate check
        final existingToday = await _db.queryWhere(
          DbConstants.tableTransactions,
          where:
              '${DbConstants.colTxnIsRecurring} = 1 '
              'AND ${DbConstants.colUserId} = ? '
              'AND date(${DbConstants.colTxnDate}) = date(?) '
              'AND ${DbConstants.colId} IN ('
              '  SELECT ${DbConstants.colTxnItemTransactionId} '
              '  FROM ${DbConstants.tableTransactionItems} '
              '  WHERE ${DbConstants.colTxnItemCategory} = ?'
              ')',
          whereArgs: [
            _userId,
            nextOccurrence.toIso8601String(),
            recurring.categoryKey,
          ],
          limit: 1,
        );

        if (existingToday.isNotEmpty) {
          print(
            '  ⚠️ Already created for ${nextOccurrence.toIso8601String()} — skipping duplicate',
          );
          nextOccurrence = _calculateNextOccurrence(recurring, nextOccurrence);
          await _db.update(
            DbConstants.tableRecurringTransactions,
            {
              DbConstants.colRecurringNextOccurrence: nextOccurrence
                  .toIso8601String(),
              DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
            },
            where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
            whereArgs: [recurring.id, _userId],
          );
          continue;
        }

        // Create transaction
        final transaction = _createTransaction(
          recurring,
          categories,
          date: nextOccurrence,
        );

        await _db.runTransaction((txn) async {
          await txn.insert(DbConstants.tableTransactions, transaction.toMap());
          for (final item in transaction.items) {
            final itemModel = TransactionItemModel(
              transactionId: transaction.id,
              category: item.category,
              amount: item.amount,
              note: item.note,
            );
            await txn.insert(
              DbConstants.tableTransactionItems,
              itemModel.toMap(),
            );
          }
        });

        // ✅ Read current stored generated IDs from DB
        final currentRow = await _db.queryWhere(
          DbConstants.tableRecurringTransactions,
          where: '${DbConstants.colId} = ?',
          whereArgs: [recurring.id],
          limit: 1,
        );

        List<String> storedIds = [];
        if (currentRow.isNotEmpty) {
          final raw = currentRow.first[DbConstants.colRecurringGeneratedIds];
          if (raw != null && raw.toString().isNotEmpty) {
            try {
              storedIds = List<String>.from(jsonDecode(raw.toString()));
            } catch (_) {
              storedIds = [];
            }
          }
        }

        // ✅ Append new transaction ID
        storedIds.add(transaction.id);

        // Advance next occurrence
        nextOccurrence = _calculateNextOccurrence(recurring, nextOccurrence);

        // ✅ Update with generated IDs + next occurrence together
        await _db.update(
          DbConstants.tableRecurringTransactions,
          {
            DbConstants.colRecurringNextOccurrence: nextOccurrence
                .toIso8601String(),
            DbConstants.colRecurringGeneratedIds: jsonEncode(
              storedIds,
            ), // ✅ saved!
            DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
          },
          where: '${DbConstants.colId} = ? AND ${DbConstants.colUserId} = ?',
          whereArgs: [recurring.id, _userId],
        );

        createdCount++;
        print('  ✅ CREATED ${transaction.id}');
        print('  📅 Next set to: $nextOccurrence');
        print('  🗂 Total stored IDs: ${storedIds.length}');

        if (createdCount >= 365) {
          print('  ⚠️ Safety cap reached (365), stopping catch-up.');
          break;
        }
      }

      print('  📊 Total created for ${recurring.categoryKey}: $createdCount');
    }

    final txnCount = await _db.rawQuery(
      'SELECT COUNT(*) as c FROM ${DbConstants.tableTransactions}',
    );
    print('✅ Done. Total transactions: ${txnCount.first['c']}');
  }

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    await Workmanager().registerPeriodicTask(
      'recurring-processor',
      'processRecurring',
      frequency: const Duration(hours: 6),
      initialDelay: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );

    print('✅ WorkManager initialized — backup check every 6 hours');
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }

  static Future<void> debugPrintRecurringState() async {
    final userId = AppPrefs.instance.userId ?? '';
    final rows = await SqliteHelper.instance.queryWhere(
      DbConstants.tableRecurringTransactions,
      where: '${DbConstants.colUserId} = ?',
      whereArgs: [userId],
    );
    print('══════════ RECURRING DEBUG ══════════');
    print('User: $userId');
    print('Total recurring: ${rows.length}');
    for (final r in rows) {
      print('  id: ${r['id']}');
      print('  category: ${r['category_key']}');
      print('  frequency: ${r['frequency']}');
      print('  next_occurrence: ${r['next_occurrence']}');
      print('  is_active: ${r['is_active']}');
      print('  end_date: ${r['end_date']}');
      print('  generated_ids: ${r['generated_transaction_ids']}');
      print('  ────────────────────────');
    }
    print('════════════════════════════════════');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────────────────────────────────────────

TransactionModel _createTransaction(
  RecurringTransactionModel recurring,
  List<CategoryModel> categories, {
  required DateTime date,
}) {
  final category = categories.firstWhere(
    (c) => c.key == recurring.categoryKey,
    orElse: () => CategoryModel(
      key: recurring.categoryKey,
      iconCode: 0xe88a,
      colorValue: 0xFF9C27B0,
      isIncome: recurring.type == TransactionType.income,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  final id = const Uuid().v4();
  final now = DateTime.now();
  final userId = AppPrefs.instance.userId;

  return TransactionModel(
    id: id,
    type: recurring.type,
    items: [
      TransactionItemModel(
        transactionId: id,
        category: category.key,
        amount: recurring.amount,
        note: recurring.note ?? '',
      ),
    ],
    totalAmount: recurring.amount,
    paymentMethod: recurring.paymentMethod,
    date: date,
    isRecurring: true,
    tags: ['auto-generated'],
    userId: userId,
    createdAt: now,
    updatedAt: now,
  );
}

DateTime _calculateNextOccurrence(
  RecurringTransactionModel recurring,
  DateTime current,
) {
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
