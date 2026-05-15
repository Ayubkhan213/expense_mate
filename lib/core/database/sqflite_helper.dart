// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendio/core/data/repository_imp/db_constants.dart';
import 'package:sqflite/sqflite.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SqliteHelper — singleton wrapper around sqflite.
///
/// Responsibilities:
///  • Open / create / migrate the database.
///  • Expose typed CRUD helpers (insert, queryAll, queryWhere, update, delete).
///  • Provide database export & reset utilities.
/// ─────────────────────────────────────────────────────────────────────────────
class SqliteHelper {
  SqliteHelper._internal();
  static final SqliteHelper instance = SqliteHelper._internal();

  static Database? _db;

  // ── Public accessor ─────────────────────────────────────────────────────────
  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  // ── Init ────────────────────────────────────────────────────────────────────
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbConstants.dbName);
    print('[SqliteHelper] DB path → $path');

    return openDatabase(
      path,
      version: DbConstants.dbVersion,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ── Schema ──────────────────────────────────────────────────────────────────
  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    // ── users ────────────────────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableUsers} (
        ${DbConstants.colId}              TEXT PRIMARY KEY NOT NULL,
        ${DbConstants.colUserName}        TEXT NOT NULL,
        ${DbConstants.colUserEmail}       TEXT UNIQUE NOT NULL,
        ${DbConstants.colUserPhone}       TEXT,
        ${DbConstants.colUserProfilePic}  TEXT,
        ${DbConstants.colUserCurrency}    TEXT NOT NULL DEFAULT 'USD',
        ${DbConstants.colUserPasswordHash} TEXT,
        ${DbConstants.colUserIsLoggedIn}  INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colUserLastLoginAt} TEXT NOT NULL,
        ${DbConstants.colUserPin}         TEXT,
        ${DbConstants.colUserUseBiometric} INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colUserSecurityQ1}  TEXT,
        ${DbConstants.colUserSecurityA1}  TEXT,
        ${DbConstants.colUserSecurityQ2}  TEXT,
        ${DbConstants.colUserSecurityA2}  TEXT,
        ${DbConstants.colUserRecoveryKeys} TEXT,
        ${DbConstants.colCreatedAt}       TEXT NOT NULL,
        ${DbConstants.colUpdatedAt}       TEXT NOT NULL
      )
    ''');

    // ── categories ───────────────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableCategories} (
        ${DbConstants.colId}                  INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colUserId}              TEXT,
        ${DbConstants.colCategoryKey}         TEXT NOT NULL,
        ${DbConstants.colCategoryIconCode}    INTEGER NOT NULL,
        ${DbConstants.colCategoryColorValue}  INTEGER NOT NULL,
        ${DbConstants.colCategoryIsIncome}    INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colIsActive}            INTEGER NOT NULL DEFAULT 1,
        ${DbConstants.colCreatedAt}           TEXT NOT NULL,
        ${DbConstants.colUpdatedAt}           TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colUserId})
          REFERENCES ${DbConstants.tableUsers}(${DbConstants.colId})
          ON DELETE SET NULL,
        UNIQUE (${DbConstants.colUserId}, ${DbConstants.colCategoryKey})
      )
    ''');

    // ── transactions ─────────────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableTransactions} (
        ${DbConstants.colId}                TEXT PRIMARY KEY NOT NULL,
        ${DbConstants.colUserId}            TEXT,
        ${DbConstants.colTxnType}           TEXT NOT NULL,
        ${DbConstants.colTxnTotalAmount}    REAL NOT NULL,
        ${DbConstants.colTxnPaymentMethod}  TEXT NOT NULL,
        ${DbConstants.colTxnDate}           TEXT NOT NULL,
        ${DbConstants.colTxnIsDebt}         INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colTxnDebtId}         TEXT,
        ${DbConstants.colTxnTags}           TEXT,
        ${DbConstants.colTxnAttachmentPath} TEXT,
        ${DbConstants.colTxnIsRecurring}    INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colTxnBudgetId}       TEXT,
        ${DbConstants.colIsDeleted}         INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colCreatedAt}         TEXT NOT NULL,
        ${DbConstants.colUpdatedAt}         TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colUserId})
          REFERENCES ${DbConstants.tableUsers}(${DbConstants.colId})
          ON DELETE SET NULL
      )
    ''');

    // ── transaction_items ────────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableTransactionItems} (
        ${DbConstants.colId}                    INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colTxnItemTransactionId}  TEXT NOT NULL,
        ${DbConstants.colTxnItemCategory}       TEXT NOT NULL,
        ${DbConstants.colTxnItemAmount}         REAL NOT NULL,
        ${DbConstants.colTxnItemNote}           TEXT,
        FOREIGN KEY (${DbConstants.colTxnItemTransactionId})
          REFERENCES ${DbConstants.tableTransactions}(${DbConstants.colId})
          ON DELETE CASCADE
      )
    ''');

    // ── budgets ──────────────────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableBudgets} (
        ${DbConstants.colId}                TEXT PRIMARY KEY NOT NULL,
        ${DbConstants.colUserId}            TEXT,
        ${DbConstants.colBudgetName}        TEXT NOT NULL,
        ${DbConstants.colBudgetType}        TEXT NOT NULL,
        ${DbConstants.colBudgetTotalAmount} REAL NOT NULL,
        ${DbConstants.colBudgetSpentAmount} REAL NOT NULL DEFAULT 0,
        ${DbConstants.colBudgetStartDate}   TEXT NOT NULL,
        ${DbConstants.colBudgetEndDate}     TEXT NOT NULL,
        ${DbConstants.colBudgetCategory}    TEXT,
        ${DbConstants.colBudgetIcon}        TEXT,
        ${DbConstants.colBudgetColorCode}   INTEGER,
        ${DbConstants.colIsActive}          INTEGER NOT NULL DEFAULT 1,
        ${DbConstants.colBudgetIsArchived}  INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colCreatedAt}         TEXT NOT NULL,
        ${DbConstants.colUpdatedAt}         TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colUserId})
          REFERENCES ${DbConstants.tableUsers}(${DbConstants.colId})
          ON DELETE SET NULL
      )
    ''');

    // ── debts ────────────────────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableDebts} (
        ${DbConstants.colId}                    TEXT PRIMARY KEY NOT NULL,
        ${DbConstants.colUserId}                TEXT,
        ${DbConstants.colDebtTransactionId}     TEXT NOT NULL,
        ${DbConstants.colDebtPersonName}        TEXT NOT NULL,
        ${DbConstants.colDebtTotalAmount}       REAL NOT NULL,
        ${DbConstants.colDebtType}              TEXT NOT NULL,
        ${DbConstants.colDebtExpectedReturnDate} TEXT NOT NULL,
        ${DbConstants.colDebtIsReturned}        INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colDebtPaidAmount}        REAL NOT NULL DEFAULT 0,
        ${DbConstants.colDebtPersonPhone}       TEXT,
        ${DbConstants.colDebtPersonImage}       TEXT,
        ${DbConstants.colCreatedAt}             TEXT NOT NULL,
        ${DbConstants.colUpdatedAt}             TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colUserId})
          REFERENCES ${DbConstants.tableUsers}(${DbConstants.colId})
          ON DELETE SET NULL,
        FOREIGN KEY (${DbConstants.colDebtTransactionId})
          REFERENCES ${DbConstants.tableTransactions}(${DbConstants.colId})
          ON DELETE RESTRICT
      )
    ''');

    // ── debt_payments ────────────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableDebtPayments} (
        ${DbConstants.colId}                    TEXT PRIMARY KEY NOT NULL,
        ${DbConstants.colDebtPaymentDebtId}     TEXT NOT NULL,
        ${DbConstants.colDebtPaymentAmount}     REAL NOT NULL,
        ${DbConstants.colDebtPaymentDate}       TEXT NOT NULL,
        ${DbConstants.colDebtPaymentNote}       TEXT,
        ${DbConstants.colDebtPaymentMethod}     TEXT NOT NULL,
        ${DbConstants.colDebtPaymentTransactionId} TEXT,
        ${DbConstants.colCreatedAt}             TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colDebtPaymentDebtId})
          REFERENCES ${DbConstants.tableDebts}(${DbConstants.colId})
          ON DELETE CASCADE
      )
    ''');

    // ── recurring_transactions ────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableRecurringTransactions} (
        ${DbConstants.colId}                      TEXT PRIMARY KEY NOT NULL,
        ${DbConstants.colUserId}                  TEXT,
        ${DbConstants.colRecurringCategoryKey}    TEXT NOT NULL,
        ${DbConstants.colRecurringAmount}         REAL NOT NULL,
        ${DbConstants.colRecurringNote}           TEXT,
        ${DbConstants.colRecurringFrequency}      TEXT NOT NULL,
        ${DbConstants.colRecurringType}           TEXT NOT NULL,
        ${DbConstants.colRecurringPaymentMethod}  TEXT NOT NULL,
        ${DbConstants.colRecurringStartDate}      TEXT NOT NULL,
        ${DbConstants.colRecurringEndDate}        TEXT,
        ${DbConstants.colRecurringNextOccurrence} TEXT NOT NULL,
        ${DbConstants.colRecurringGeneratedIds}   TEXT,
        ${DbConstants.colIsActive}                INTEGER NOT NULL DEFAULT 1,
        ${DbConstants.colRecurringDayOfMonth}     INTEGER NOT NULL DEFAULT 1,
        ${DbConstants.colRecurringDayOfWeek}      INTEGER,
        ${DbConstants.colCreatedAt}               TEXT NOT NULL,
        ${DbConstants.colUpdatedAt}               TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colUserId})
          REFERENCES ${DbConstants.tableUsers}(${DbConstants.colId})
          ON DELETE SET NULL
      )''');
    batch.execute('''
      CREATE TABLE currencies (
        code    TEXT PRIMARY KEY NOT NULL,
         name    TEXT NOT NULL,
         symbol  TEXT NOT NULL,
         flag    TEXT NOT NULL
       )''');

    // ── transactions_archive ─────────────────────────────────────────────────
    batch.execute('''
      CREATE TABLE ${DbConstants.tableTransactionsArchive} (
        ${DbConstants.colId}                TEXT PRIMARY KEY NOT NULL,
        ${DbConstants.colUserId}            TEXT,
        ${DbConstants.colTxnType}           TEXT NOT NULL,
        ${DbConstants.colTxnTotalAmount}    REAL NOT NULL,
        ${DbConstants.colTxnPaymentMethod}  TEXT NOT NULL,
        ${DbConstants.colTxnDate}           TEXT NOT NULL,
        ${DbConstants.colTxnIsDebt}         INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colTxnDebtId}         TEXT,
        ${DbConstants.colTxnTags}           TEXT,
        ${DbConstants.colTxnAttachmentPath} TEXT,
        ${DbConstants.colTxnIsRecurring}    INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colTxnBudgetId}       TEXT,
        ${DbConstants.colIsDeleted}         INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colCreatedAt}         TEXT NOT NULL,
        ${DbConstants.colUpdatedAt}         TEXT NOT NULL,
        ${DbConstants.colArchivedAt}        TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colUserId})
          REFERENCES ${DbConstants.tableUsers}(${DbConstants.colId})
          ON DELETE SET NULL
      )
    ''');

    await batch.commit(noResult: true);
    await _createIndexes(db);

    // ── Archive Index (Only created here because table exists in _onCreate) ──
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_arch_user_date ON ${DbConstants.tableTransactionsArchive}(${DbConstants.colUserId}, ${DbConstants.colTxnDate})',
    );
  }

  Future<void> _createIndexes(Database db) async {
    final batch = db.batch();

    // Speed up common queries
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_user_date ON ${DbConstants.tableTransactions}(${DbConstants.colUserId}, ${DbConstants.colTxnDate})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_budget ON ${DbConstants.tableTransactions}(${DbConstants.colTxnBudgetId})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_items_txn ON ${DbConstants.tableTransactionItems}(${DbConstants.colTxnItemTransactionId})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_debts_user ON ${DbConstants.tableDebts}(${DbConstants.colUserId})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_debt_payments_debt ON ${DbConstants.tableDebtPayments}(${DbConstants.colDebtPaymentDebtId})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_budgets_user ON ${DbConstants.tableBudgets}(${DbConstants.colUserId})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_recurring_user ON ${DbConstants.tableRecurringTransactions}(${DbConstants.colUserId})',
    );


    // New optimizations for large data (100k+ rows)
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_user_type_date ON ${DbConstants.tableTransactions}(${DbConstants.colUserId}, ${DbConstants.colTxnType}, ${DbConstants.colTxnDate})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_user_deleted_date ON ${DbConstants.tableTransactions}(${DbConstants.colUserId}, ${DbConstants.colIsDeleted}, ${DbConstants.colTxnDate})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_user_payment ON ${DbConstants.tableTransactions}(${DbConstants.colUserId}, ${DbConstants.colTxnPaymentMethod})',
    );
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_items_category ON ${DbConstants.tableTransactionItems}(${DbConstants.colTxnItemCategory})',
    );

    // Partial index to optimize queries that always filter by is_deleted = 0
    batch.execute(
      'CREATE INDEX IF NOT EXISTS idx_txn_partial_active ON ${DbConstants.tableTransactions}(${DbConstants.colUserId}, ${DbConstants.colTxnDate}) WHERE ${DbConstants.colIsDeleted} = 0',
    );

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration to version 2: Adding optimized indexes for large datasets
      await _createIndexes(db);
    }

    if (oldVersion < 3) {
      // Migration to version 3: Adding transaction archiving system
      final batch = db.batch();
      batch.execute('''
        CREATE TABLE IF NOT EXISTS ${DbConstants.tableTransactionsArchive} (
          ${DbConstants.colId}                TEXT PRIMARY KEY NOT NULL,
          ${DbConstants.colUserId}            TEXT,
          ${DbConstants.colTxnType}           TEXT NOT NULL,
          ${DbConstants.colTxnTotalAmount}    REAL NOT NULL,
          ${DbConstants.colTxnPaymentMethod}  TEXT NOT NULL,
          ${DbConstants.colTxnDate}           TEXT NOT NULL,
          ${DbConstants.colTxnIsDebt}         INTEGER NOT NULL DEFAULT 0,
          ${DbConstants.colTxnDebtId}         TEXT,
          ${DbConstants.colTxnTags}           TEXT,
          ${DbConstants.colTxnAttachmentPath} TEXT,
          ${DbConstants.colTxnIsRecurring}    INTEGER NOT NULL DEFAULT 0,
          ${DbConstants.colTxnBudgetId}       TEXT,
          ${DbConstants.colIsDeleted}         INTEGER NOT NULL DEFAULT 0,
          ${DbConstants.colCreatedAt}         TEXT NOT NULL,
          ${DbConstants.colUpdatedAt}         TEXT NOT NULL,
          ${DbConstants.colArchivedAt}        TEXT NOT NULL,
          FOREIGN KEY (${DbConstants.colUserId})
            REFERENCES ${DbConstants.tableUsers}(${DbConstants.colId})
            ON DELETE SET NULL
        )
      ''');
      batch.execute(
        'CREATE INDEX IF NOT EXISTS idx_arch_user_date ON ${DbConstants.tableTransactionsArchive}(${DbConstants.colUserId}, ${DbConstants.colTxnDate})',
      );
      await batch.commit(noResult: true);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Generic CRUD helpers
  // ══════════════════════════════════════════════════════════════════════════

  /// Insert a row. Returns the rowId on success, -1 on conflict.
  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
  }) async {
    final db = await database;
    return db.insert(table, values, conflictAlgorithm: conflictAlgorithm);
  }

  /// Batch insert — much faster for bulk data migration.
  Future<void> insertBatch(
    String table,
    List<Map<String, dynamic>> rows, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
  }) async {
    final db = await database;
    final batch = db.batch();
    for (final row in rows) {
      batch.insert(table, row, conflictAlgorithm: conflictAlgorithm);
    }
    await batch.commit(noResult: true);
  }

  /// Query all rows from [table], optionally limited to [columns].
  Future<List<Map<String, dynamic>>> queryAll(
    String table, {
    List<String>? columns,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(table, columns: columns, orderBy: orderBy);
  }

  /// Query rows matching [where] clause.
  Future<List<Map<String, dynamic>>> queryWhere(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
    List<String>? columns,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  /// Run a raw SELECT and return the result set.
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? args,
  ]) async {
    final db = await database;
    return db.rawQuery(sql, args);
  }

  /// Update rows matching [where]. Returns the number of affected rows.
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  /// Soft-delete: sets [colIsDeleted] = 1 + updates [colUpdatedAt].
  Future<int> softDelete(String table, String id) async {
    return update(
      table,
      {
        DbConstants.colIsDeleted: 1,
        DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// Hard-delete rows matching [where].
  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Utilities
  // ══════════════════════════════════════════════════════════════════════════

  /// Wraps multiple operations in a transaction. Rolls back on error.
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    final db = await database;
    return db.transaction(action);
  }

  /// Close the database (call on app shutdown / during tests).
  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }

  /// Delete and re-create the database file (for sign-out / data wipe).
  Future<void> deleteDatabaseFile() async {
    await close();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbConstants.dbName);
    await deleteDatabase(path);
  }

  /// Export the raw database file to Downloads (Android) or Documents (iOS).
  Future<String?> exportDatabaseToDownloads() async {
    final dbPath = await getDatabasesPath();
    final dbFile = File(join(dbPath, DbConstants.dbName));
    if (!await dbFile.exists()) return null;

    Directory targetDir;

    if (Platform.isAndroid) {
      if (!await Permission.storage.request().isGranted) return null;
      final extDir = await getExternalStorageDirectory();
      final parts = extDir!.path.split('/');
      final androidIdx = parts.indexOf('Android');
      targetDir = Directory(
        '${parts.sublist(0, androidIdx).join('/')}/Download',
      );
    } else {
      targetDir = await getApplicationDocumentsDirectory();
    }

    final targetPath = join(targetDir.path, DbConstants.dbName);
    await dbFile.copy(targetPath);
    return targetPath;
  }

  // ── Archiving ───────────────────────────────────────────────────────────────

  /// Moves transactions older than 12 months to the archive table and runs VACUUM.
  Future<int> archiveOldTransactions(String userId) async {
    try {
      final db = await database;
      final cutoff =
          DateTime.now().subtract(const Duration(days: 365)).toIso8601String();

      int archivedCount = 0;

      await db.transaction((txn) async {
        // 1. Insert into archive table
        await txn.execute('''
          INSERT OR IGNORE INTO ${DbConstants.tableTransactionsArchive} (
            ${DbConstants.colId}, ${DbConstants.colUserId}, ${DbConstants.colTxnType}, 
            ${DbConstants.colTxnTotalAmount}, ${DbConstants.colTxnPaymentMethod}, 
            ${DbConstants.colTxnDate}, ${DbConstants.colTxnIsDebt}, ${DbConstants.colTxnDebtId}, 
            ${DbConstants.colTxnTags}, ${DbConstants.colTxnAttachmentPath}, 
            ${DbConstants.colTxnIsRecurring}, ${DbConstants.colTxnBudgetId}, 
            ${DbConstants.colIsDeleted}, ${DbConstants.colCreatedAt}, 
            ${DbConstants.colUpdatedAt}, ${DbConstants.colArchivedAt}
          )
          SELECT 
            ${DbConstants.colId}, ${DbConstants.colUserId}, ${DbConstants.colTxnType}, 
            ${DbConstants.colTxnTotalAmount}, ${DbConstants.colTxnPaymentMethod}, 
            ${DbConstants.colTxnDate}, ${DbConstants.colTxnIsDebt}, ${DbConstants.colTxnDebtId}, 
            ${DbConstants.colTxnTags}, ${DbConstants.colTxnAttachmentPath}, 
            ${DbConstants.colTxnIsRecurring}, ${DbConstants.colTxnBudgetId}, 
            ${DbConstants.colIsDeleted}, ${DbConstants.colCreatedAt}, 
            ${DbConstants.colUpdatedAt}, ?
          FROM ${DbConstants.tableTransactions}
          WHERE ${DbConstants.colUserId} = ? AND ${DbConstants.colTxnDate} < ?
        ''', [DateTime.now().toIso8601String(), userId, cutoff]);

        // 2. Delete from main table
        archivedCount = await txn.delete(
          DbConstants.tableTransactions,
          where: '${DbConstants.colUserId} = ? AND ${DbConstants.colTxnDate} < ?',
          whereArgs: [userId, cutoff],
        );
      });

      if (archivedCount > 0) {
        await db.execute('VACUUM');
        print('[Archive] Moved $archivedCount rows to archive');
      }

      return archivedCount;
    } catch (e) {
      print('[Archive Error] Failed to archive old transactions: $e');
      return 0;
    }
  }

  /// Silently checks and triggers archiving if old data exceeds 500 rows.
  Future<void> checkAndArchive(String userId) async {
    try {
      final db = await database;
      final cutoff =
          DateTime.now().subtract(const Duration(days: 365)).toIso8601String();

      final result = await db.rawQuery('''
        SELECT COUNT(*) as count 
        FROM ${DbConstants.tableTransactions} 
        WHERE ${DbConstants.colUserId} = ? AND ${DbConstants.colTxnDate} < ?
      ''', [userId, cutoff]);

      final count = Sqflite.firstIntValue(result) ?? 0;

      if (count > 500) {
        await archiveOldTransactions(userId);
      }
    } catch (e) {
      print('[Archive Error] Check and archive failed: $e');
    }
  }

  /// Fetches paginated archived transactions for a specific user and date range.
  Future<List<Map<String, dynamic>>> getArchivedTransactions(
    String userId,
    DateTime from,
    DateTime to,
    int page,
  ) async {
    try {
      final db = await database;
      const int pageSize = 30;
      final int offset = page * pageSize;

      return await db.query(
        DbConstants.tableTransactionsArchive,
        where:
            '${DbConstants.colUserId} = ? AND ${DbConstants.colTxnDate} BETWEEN ? AND ?',
        whereArgs: [userId, from.toIso8601String(), to.toIso8601String()],
        orderBy: '${DbConstants.colTxnDate} DESC',
        limit: pageSize,
        offset: offset,
      );
    } catch (e) {
      print('[Archive Error] Failed to fetch archived transactions: $e');
      return [];
    }
  }
}
