import 'package:expense_mate/core/data/data_sources/local/category_seeder.dart';
import 'package:expense_mate/core/data/data_sources/local/currencies_seeding.dart';
import 'package:expense_mate/core/data/models/budget_model.dart'
    hide BudgetTypeAdapter;
import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/currency_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';

import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/transaction_model.dart';
import '../data/models/transaction_item_model.dart';
import '../data/models/debt_model.dart';

class HiveInitializer {
  static const String transactionBox = 'transactions';
  static const String debtBox = 'debts';
  static const String debtPaymentBox = 'debt_payments';
  static const String budgetBox = 'budgets';
  static const String categoryBox = 'categories';
  static const String userBox = 'users';
  static const String recurringTransactionBox = 'recurring_transactions';
  static const String currencyBox = 'currencies';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (ONLY ONCE)
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TransactionItemAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DebtModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(BudgetModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(RecurringTransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(DebtPaymentModelAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(CurrencyModelAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(TransactionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(DebtTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(PaymentMethodAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(BudgetTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(RecurrenceFrequencyAdapter());
    }
    //  Open ALL boxes
    await Hive.openBox<TransactionModel>(transactionBox);
    await Hive.openBox<DebtModel>(debtBox);
    await Hive.openBox<DebtPaymentModel>(debtPaymentBox);
    await Hive.openBox<BudgetModel>(budgetBox);
    await Hive.openBox<CategoryHiveModel>(categoryBox);
    await Hive.openBox<UserModel>(userBox);
    await Hive.openBox<RecurringTransactionModel>(recurringTransactionBox);
    await Hive.openBox<CurrencyModel>(currencyBox);

    //  Seed default categories (ONLY FIRST TIME)
    await CategorySeeder.seedIfFirstTime();
    await CurrenciesSeeding.seedCurrenciesIfFirstTime();
  }
}
