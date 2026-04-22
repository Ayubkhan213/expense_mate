// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// ─────────────────────────────────────────────────────────────────────────────
///  DummyAccountSeeder
///  Runs ONCE on first install — guarded by seeder_flags table.
///  Email: ayub@gmail.com  |  Password: ayub123  |  PIN: 1234
/// ─────────────────────────────────────────────────────────────────────────────
class DummyAccountSeeder {
  DummyAccountSeeder._();

  static final _db = SqliteHelper.instance;
  static const _uuid = Uuid();

  static const String dummyEmail = 'demo@gmail.com';
  static const String dummyPassword = 'demo1234';
  static const String _userId = 'dummy-spendio-uid-001';

  static const String _guardTable = 'seeder_flags';

  // ✅ bumped to v5 for new credentials
  static const String _guardKey = 'dummy_account_v5';

  // Pre-generated UUIDs so FK links are consistent
  static final String _txSalary = _uuid.v4();
  static final String _txFreelance = _uuid.v4();
  static final String _txBonus = _uuid.v4();
  static final String _txGroceries = _uuid.v4();
  static final String _txElectricity = _uuid.v4();
  static final String _txInternet = _uuid.v4();
  static final String _txRestaurant = _uuid.v4();
  static final String _txTransport = _uuid.v4();
  static final String _txMedicine = _uuid.v4();
  static final String _txShopping = _uuid.v4();
  static final String _txFuel = _uuid.v4();
  static final String _txCoffee = _uuid.v4();
  static final String _txDebtAhmad = _uuid.v4();
  static final String _txDebtAli = _uuid.v4();
  static final String _debtAhmadId = _uuid.v4();
  static final String _debtAliId = _uuid.v4();

  // ═══════════════════════════════════════════════════════════════════════════
  //  ENTRY POINT
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<void> seedIfFirstTime() async {
    final db = await _db.database;

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_guardTable (
        flag_key   TEXT PRIMARY KEY,
        created_at TEXT NOT NULL
      )
    ''');

    final existing = await db.query(
      _guardTable,
      where: 'flag_key = ?',
      whereArgs: [_guardKey],
    );
    if (existing.isNotEmpty) return;

    print('🌱 [DummyAccountSeeder] Seeding...');

    try {
      await _seedUser(db);
      await _seedTransactions(db);
      await _seedTransactionItems(db);
      await _seedDebtTransactions(db);
      await _seedDebts(db);
      await _seedBudgets(db);
      await _seedRecurring(db);

      await db.insert(_guardTable, {
        'flag_key': _guardKey,
        'created_at': _now(),
      });

      print('✅ [DummyAccountSeeder] Done!');
      print('   📧 Email   : $dummyEmail');
      print('   🔑 Password: $dummyPassword');
      print('   🔢 PIN     : 0987');
    } catch (e, st) {
      print('❌ [DummyAccountSeeder] Error: $e\n$st');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  USER
  // ═══════════════════════════════════════════════════════════════════════════
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static Future<void> _seedUser(Database db) async {
    await db.insert('users', {
      'id': _userId,
      'name': 'Ayub Khan',
      'email': dummyEmail,
      'phone_number': '+92-300-0000000',
      'profile_picture_path': null,
      'currency': 'PKR',
      'password_hash': _hashPassword(dummyPassword),
      'is_logged_in': 0,
      'last_login_at': _now(),
      'pin': '0987',
      'use_biometric': 0,
      'security_question_1': null,
      'security_answer_1': null,
      'security_question_2': null,
      'security_answer_2': null,
      'recovery_keys': null,
      'created_at': _now(),
      'updated_at': _now(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<void> _seedTransactions(Database db) async {
    final txns = [
      _txMap(_txSalary, 'income', 50000, 'bank', -30),
      _txMap(_txFreelance, 'income', 15000, 'bank', -20),
      _txMap(_txBonus, 'income', 8000, 'bank', -10),
      _txMap(_txGroceries, 'expense', 3500, 'cash', -28),
      _txMap(_txElectricity, 'expense', 2200, 'bank', -25),
      _txMap(_txInternet, 'expense', 999, 'bank', -22),
      _txMap(_txRestaurant, 'expense', 1800, 'cash', -15),
      _txMap(_txTransport, 'expense', 600, 'cash', -12),
      _txMap(_txMedicine, 'expense', 450, 'cash', -8),
      _txMap(_txShopping, 'expense', 4500, 'card', -5),
      _txMap(_txFuel, 'expense', 800, 'cash', -3),
      _txMap(_txCoffee, 'expense', 250, 'cash', -1),
    ];
    for (final t in txns) {
      await db.insert(
        'transactions',
        t,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  static Map<String, dynamic> _txMap(
    String id,
    String type,
    double amount,
    String paymentMethod,
    int daysAgo, {
    bool isDebt = false,
    String? debtId,
  }) => {
    'id': id,
    'user_id': _userId,
    'type': type,
    'total_amount': amount,
    'payment_method': paymentMethod,
    'date': _daysAgo(daysAgo),
    'is_debt': isDebt ? 1 : 0,
    'debt_id': debtId,
    'tags': null,
    'attachment_path': null,
    'is_recurring': 0,
    'budget_id': null,
    'is_deleted': 0,
    'created_at': _now(),
    'updated_at': _now(),
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  TRANSACTION ITEMS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<void> _seedTransactionItems(Database db) async {
    final items = [
      _itemMap(_txSalary, 'salary', 50000, 'Monthly salary'),
      _itemMap(_txFreelance, 'freelance', 15000, 'App development project'),
      _itemMap(_txBonus, 'bonus', 8000, 'Performance bonus'),
      _itemMap(_txGroceries, 'groceries', 3500, 'Weekly groceries'),
      _itemMap(_txElectricity, 'utilities', 2200, 'Electricity bill'),
      _itemMap(_txInternet, 'utilities', 999, 'Internet bill'),
      _itemMap(_txRestaurant, 'food', 1800, 'Family dinner'),
      _itemMap(_txTransport, 'transport', 600, 'Fuel and rickshaw'),
      _itemMap(_txMedicine, 'health', 450, 'Pharmacy'),
      _itemMap(_txShopping, 'shopping', 4500, 'Clothes shopping'),
      _itemMap(_txFuel, 'transport', 800, 'Petrol'),
      _itemMap(_txCoffee, 'food', 250, 'Cafe coffee'),
    ];
    for (final item in items) {
      await db.insert(
        'transaction_items',
        item,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  static Map<String, dynamic> _itemMap(
    String transactionId,
    String category,
    double amount,
    String note,
  ) => {
    'transaction_id': transactionId,
    'category': category,
    'amount': amount,
    'note': note,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  DEBT TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<void> _seedDebtTransactions(Database db) async {
    final debtTxns = [
      _txMap(
        _txDebtAhmad,
        'expense',
        7900,
        'cash',
        -45,
        isDebt: true,
        debtId: _debtAhmadId,
      ),
      _txMap(
        _txDebtAli,
        'income',
        2000,
        'cash',
        -30,
        isDebt: true,
        debtId: _debtAliId,
      ),
    ];
    for (final t in debtTxns) {
      await db.insert(
        'transactions',
        t,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await db.insert(
      'transaction_items',
      _itemMap(_txDebtAhmad, 'debt', 7900, 'Borrowed from Ahmad'),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await db.insert(
      'transaction_items',
      _itemMap(_txDebtAli, 'debt', 2000, 'Lent to Ali'),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  DEBTS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<void> _seedDebts(Database db) async {
    final debts = [
      {
        'id': _debtAhmadId,
        'user_id': _userId,
        'transaction_id': _txDebtAhmad,
        'person_name': 'Ahmad',
        'total_amount': 7900.0,
        'debt_type': 'borrowed',
        'expected_return_date': _daysFromNow(60),
        'is_returned': 0,
        'paid_amount': 0.0,
        'person_phone': '+92-300-1111111',
        'person_image': null,
        'created_at': _now(),
        'updated_at': _now(),
      },
      {
        'id': _debtAliId,
        'user_id': _userId,
        'transaction_id': _txDebtAli,
        'person_name': 'Ali',
        'total_amount': 2000.0,
        'debt_type': 'lent',
        'expected_return_date': _daysFromNow(30),
        'is_returned': 0,
        'paid_amount': 0.0,
        'person_phone': '+92-300-2222222',
        'person_image': null,
        'created_at': _now(),
        'updated_at': _now(),
      },
    ];
    for (final d in debts) {
      await db.insert('debts', d, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BUDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<void> _seedBudgets(Database db) async {
    final start = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final end = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

    final budgets = [
      _budgetMap('Groceries', 10000, 3500, 'groceries', start, end, 0xFF4CAF50),
      _budgetMap('Transport', 3000, 600, 'transport', start, end, 0xFF2196F3),
      _budgetMap(
        'Entertainment',
        5000,
        0,
        'entertainment',
        start,
        end,
        0xFF9C27B0,
      ),
      _budgetMap('Health', 4000, 450, 'health', start, end, 0xFFE91E63),
    ];
    for (final b in budgets) {
      await db.insert(
        'budgets',
        b,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  static Map<String, dynamic> _budgetMap(
    String name,
    double total,
    double spent,
    String category,
    DateTime start,
    DateTime end,
    int colorCode,
  ) => {
    'id': _uuid.v4(),
    'user_id': _userId,
    'name': name,
    'type': 'monthly',
    'total_amount': total,
    'spent_amount': spent,
    'start_date': start.toIso8601String(),
    'end_date': end.toIso8601String(),
    'category': category,
    'icon': null,
    'color_code': colorCode,
    'is_active': 1,
    'is_archived': 0,
    'created_at': _now(),
    'updated_at': _now(),
  };

  // ═══════════════════════════════════════════════════════════════════════════
  //  RECURRING
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<void> _seedRecurring(Database db) async {
    final now = DateTime.now();

    final recurring = [
      // ── Monthly recurring (unchanged) ─────────────────────────────────────
      _recurringMonthly('Monthly Salary', 50000, 'income', 'salary', 1),
      _recurringMonthly('Netflix', 450, 'expense', 'entertainment', 5),
      _recurringMonthly('Gym Membership', 1500, 'expense', 'health', 10),
      _recurringMonthly('Internet Bill', 999, 'expense', 'utilities', 15),

      // ✅ DAILY TEST RECURRING ──────────────────────────────────────────────
      // next_occurrence = yesterday so it's already DUE when app opens
      // end_date        = tomorrow so it expires after ONE generation
      // When processRecurringTransactions() runs it will:
      //   1. See yesterday is due  → create 1 transaction
      //   2. Advance next to today → still due  → create 1 more
      //   3. Advance next to tomorrow → NOT due → stop
      // Result: you see exactly 1-2 transactions generated on first open
      {
        'id': _uuid.v4(),
        'user_id': _userId,
        'category_key': 'food', // ← must exist in your categories
        'amount': 100.0,
        'note': '🧪 Daily Test Recurring',
        'frequency': 'daily',
        'type': 'expense',
        'payment_method': 'cash',
        'start_date': _daysAgo(2), // started 2 days ago
        'end_date': _daysFromNow(1), // expires tomorrow → limited life
        'next_occurrence': _daysAgo(1), // ← yesterday = already DUE
        'generated_transaction_ids': null,
        'day_of_month': 1,
        'day_of_week': null,
        'is_active': 1,
        'created_at': _now(),
        'updated_at': _now(),
      },
    ];

    for (final r in recurring) {
      await db.insert(
        'recurring_transactions',
        r,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  /// Helper for monthly recurring entries
  static Map<String, dynamic> _recurringMonthly(
    String note,
    double amount,
    String type,
    String categoryKey,
    int dayOfMonth,
  ) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, dayOfMonth);
    final next = DateTime(now.year, now.month + 1, dayOfMonth);
    return {
      'id': _uuid.v4(),
      'user_id': _userId,
      'category_key': categoryKey,
      'amount': amount,
      'note': note,
      'frequency': 'monthly',
      'type': type,
      'payment_method': type == 'income' ? 'bank' : 'cash',
      'start_date': start.toIso8601String(),
      'end_date': null,
      'next_occurrence': next.toIso8601String(),
      'generated_transaction_ids': null,
      'day_of_month': dayOfMonth,
      'day_of_week': null,
      'is_active': 1,
      'created_at': _now(),
      'updated_at': _now(),
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  static String _now() => DateTime.now().toIso8601String();

  static String _daysAgo(int days) =>
      DateTime.now().subtract(Duration(days: days)).toIso8601String();

  static String _daysFromNow(int days) =>
      DateTime.now().add(Duration(days: days)).toIso8601String();
}
