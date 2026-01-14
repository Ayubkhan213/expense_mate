import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_mate/core/data/data_sources/local/category_seeder.dart';
import 'package:expense_mate/core/data/data_sources/local/currencies_seeding.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_item_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/data/models/currency_model.dart';
import 'package:expense_mate/core/data/models/enums.dart'
    hide BudgetTypeAdapter;

class HiveInitializer {
  /// Initialize Hive (call this ONCE at app startup)
  static Future<void> init() async {
    // 1. Initialize Hive Flutter
    await Hive.initFlutter();

    // 2. Register all adapters
    await _registerAdapters();

    // 3. Open all boxes via BoxManager
    await HiveBoxManager.initialize();

    // 4. Seed default data (only first time)
    await _seedDefaultData();
  }

  /// Register all Hive type adapters
  static Future<void> _registerAdapters() async {
    // Models
    _registerAdapterIfNeeded(1, TransactionModelAdapter());
    _registerAdapterIfNeeded(2, TransactionItemAdapter());
    _registerAdapterIfNeeded(3, DebtModelAdapter());
    _registerAdapterIfNeeded(4, BudgetModelAdapter());
    _registerAdapterIfNeeded(5, CategoryHiveModelAdapter());
    _registerAdapterIfNeeded(6, UserModelAdapter());
    _registerAdapterIfNeeded(7, RecurringTransactionModelAdapter());
    _registerAdapterIfNeeded(8, DebtPaymentModelAdapter());
    _registerAdapterIfNeeded(14, CurrencyModelAdapter());

    // Enums
    _registerAdapterIfNeeded(10, TransactionTypeAdapter());
    _registerAdapterIfNeeded(11, DebtTypeAdapter());
    _registerAdapterIfNeeded(12, PaymentMethodAdapter());
    _registerAdapterIfNeeded(13, BudgetTypeAdapter());
    _registerAdapterIfNeeded(15, RecurrenceFrequencyAdapter());
  }

  /// Helper to register adapter only if not already registered
  static void _registerAdapterIfNeeded<T>(int typeId, TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
  }

  /// Seed default data on first launch
  static Future<void> _seedDefaultData() async {
    await CategorySeeder.seedIfFirstTime();
    await CurrenciesSeeding.seedCurrenciesIfFirstTime();
  }
}
