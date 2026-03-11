import 'package:expense_mate/core/database/sqflite_helper.dart';

import '../../../../../core/data/models/recurring_transcation_sql_model.dart';
import '../../../../../core/database/db_constants.dart' show DbConstants;

abstract class RecurringLocalDataSource {
  Future<void> createRecurring(RecurringTransactionModel recurring);
  Future<void> toggleActive(String id);
  Future<void> updateRecurring(RecurringTransactionModel recurring);
  Future<void> deleteRecurring(String id);
  Future<List<RecurringTransactionModel>> getAllRecurring();
  Future<List<RecurringTransactionModel>> getActiveRecurring();
  Future<RecurringTransactionModel?> getRecurringById(String id);
  Future<List<RecurringTransactionModel>> getDueRecurring();
}

// ─────────────────────────────────────────────────────────────────────────────

class RecurringLocalDataSourceImpl implements RecurringLocalDataSource {
  final SqliteHelper _db = SqliteHelper.instance;

  // ═══════════════════════════════════════════════════════════════════════════
  // WRITE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> createRecurring(RecurringTransactionModel recurring) async {
    try {
      await _db.insert(
        DbConstants.tableRecurringTransactions,
        RecurringTransactionModel.fromEntity(recurring).toMap(),
      );
    } catch (e, st) {
      print('createRecurring error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> toggleActive(String id) async {
    try {
      // Read current value first, then flip it
      final rows = await _db.queryWhere(
        DbConstants.tableRecurringTransactions,
        where: '${DbConstants.colId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isEmpty) return;

      final current = rows.first[DbConstants.colIsActive] as int? ?? 1;
      await _db.update(
        DbConstants.tableRecurringTransactions,
        {DbConstants.colIsActive: current == 1 ? 0 : 1},
        where: '${DbConstants.colId} = ?',
        whereArgs: [id],
      );
    } catch (e, st) {
      print('toggleActive error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> updateRecurring(RecurringTransactionModel recurring) async {
    try {
      await _db.update(
        DbConstants.tableRecurringTransactions,
        RecurringTransactionModel.fromEntity(recurring).toMap(),
        where: '${DbConstants.colId} = ?',
        whereArgs: [recurring.id],
      );
    } catch (e, st) {
      print('updateRecurring error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> deleteRecurring(String id) async {
    try {
      await _db.delete(
        DbConstants.tableRecurringTransactions,
        where: '${DbConstants.colId} = ?',
        whereArgs: [id],
      );
    } catch (e, st) {
      print('deleteRecurring error: $e\n$st');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // READ
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<List<RecurringTransactionModel>> getAllRecurring() async {
    try {
      final rows = await _db.queryAll(
        DbConstants.tableRecurringTransactions,
        orderBy: '${DbConstants.colCreatedAt} DESC',
      );
      return rows.map((r) => RecurringTransactionModel.fromMap(r)).toList();
    } catch (e, st) {
      print('getAllRecurring error: $e\n$st');
      return [];
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getActiveRecurring() async {
    try {
      // Active = is_active=1 AND (end_date IS NULL OR end_date > now)
      final now = DateTime.now().toIso8601String();
      final rows = await _db.queryWhere(
        DbConstants.tableRecurringTransactions,
        where:
            '${DbConstants.colIsActive} = 1 AND (${DbConstants.colRecurringEndDate} IS NULL OR ${DbConstants.colRecurringEndDate} > ?)',
        whereArgs: [now],
        orderBy: '${DbConstants.colRecurringNextOccurrence} ASC',
      );
      return rows.map((r) => RecurringTransactionModel.fromMap(r)).toList();
    } catch (e, st) {
      print('getActiveRecurring error: $e\n$st');
      return [];
    }
  }

  @override
  Future<RecurringTransactionModel?> getRecurringById(String id) async {
    try {
      final rows = await _db.queryWhere(
        DbConstants.tableRecurringTransactions,
        where: '${DbConstants.colId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return RecurringTransactionModel.fromMap(rows.first);
    } catch (e, st) {
      print('getRecurringById error: $e\n$st');
      return null;
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getDueRecurring() async {
    try {
      final now = DateTime.now();
      // Normalise to start-of-day so a due-today item is always included
      final todayStart = DateTime(
        now.year,
        now.month,
        now.day,
      ).toIso8601String();

      final rows = await _db.queryWhere(
        DbConstants.tableRecurringTransactions,
        where:
            '${DbConstants.colIsActive} = 1 '
            'AND (${DbConstants.colRecurringEndDate} IS NULL OR ${DbConstants.colRecurringEndDate} > ?) '
            'AND ${DbConstants.colRecurringNextOccurrence} <= ?',
        whereArgs: [todayStart, todayStart],
        orderBy: '${DbConstants.colRecurringNextOccurrence} ASC',
      );
      return rows.map((r) => RecurringTransactionModel.fromMap(r)).toList();
    } catch (e, st) {
      print('getDueRecurring error: $e\n$st');
      return [];
    }
  }
}
