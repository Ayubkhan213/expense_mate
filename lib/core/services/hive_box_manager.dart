import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';

class HiveBoxManager {
  // Box names (constants)
  static const String _transactionBoxName = 'transactions';
  static const String _debtBoxName = 'debts';
  static const String _debtPaymentBoxName = 'debt_payments';
  static const String _budgetBoxName = 'budgets';
  static const String _categoryBoxName = 'categories';
  static const String _userBoxName = 'users';
  static const String _recurringBoxName = 'recurring_transactions';
  static const String _currencyBoxName = 'currencies';
  static const String _settingsBoxName = 'settings';
  static const String _languageBoxName = 'languageBox'; // Add this

  // Private box instances
  static late Box<TransactionModel> _transactionBox;
  static late Box<DebtModel> _debtBox;
  static late Box<DebtPaymentModel> _debtPaymentBox;
  static late Box<BudgetModel> _budgetBox;
  static late Box<CategoryHiveModel> _categoryBox;
  static late Box<UserModel> _userBox;
  static late Box<RecurringTransactionModel> _recurringBox;
  static late Box<CurrencyModel> _currencyBox;
  static late Box _settingsBox;
  static late Box _languageBox; // Add this

  // Public getters
  static Box<TransactionModel> get transactions => _transactionBox;
  static Box<DebtModel> get debts => _debtBox;
  static Box<DebtPaymentModel> get debtPayments => _debtPaymentBox;
  static Box<BudgetModel> get budgets => _budgetBox;
  static Box<CategoryHiveModel> get categories => _categoryBox;
  static Box<UserModel> get users => _userBox;
  static Box<RecurringTransactionModel> get recurring => _recurringBox;
  static Box<CurrencyModel> get currencies => _currencyBox;
  static Box get settings => _settingsBox;
  static Box get language => _languageBox; // Add this

  static Future<void> initialize() async {
    _transactionBox = await Hive.openBox<TransactionModel>(_transactionBoxName);
    _debtBox = await Hive.openBox<DebtModel>(_debtBoxName);
    _debtPaymentBox = await Hive.openBox<DebtPaymentModel>(_debtPaymentBoxName);
    _budgetBox = await Hive.openBox<BudgetModel>(_budgetBoxName);
    _categoryBox = await Hive.openBox<CategoryHiveModel>(_categoryBoxName);
    _userBox = await Hive.openBox<UserModel>(_userBoxName);
    _recurringBox = await Hive.openBox<RecurringTransactionModel>(
      _recurringBoxName,
    );
    _currencyBox = await Hive.openBox<CurrencyModel>(_currencyBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _languageBox = await Hive.openBox(_languageBoxName); // Add this
  }

  static Future<void> closeAll() async {
    await _transactionBox.close();
    await _debtBox.close();
    await _debtPaymentBox.close();
    await _budgetBox.close();
    await _categoryBox.close();
    await _userBox.close();
    await _recurringBox.close();
    await _currencyBox.close();
    await _settingsBox.close();
    await _languageBox.close(); // Add this
  }

  static Future<void> clearAll() async {
    await _transactionBox.clear();
    await _debtBox.clear();
    await _debtPaymentBox.clear();
    await _budgetBox.clear();
    await _categoryBox.clear();
    await _userBox.clear();
    await _recurringBox.clear();
    await _currencyBox.clear();
    // Don't clear settings/language by default
  }

  static Future<void> deleteAll() async {
    await Hive.deleteBoxFromDisk(_transactionBoxName);
    await Hive.deleteBoxFromDisk(_debtBoxName);
    await Hive.deleteBoxFromDisk(_debtPaymentBoxName);
    await Hive.deleteBoxFromDisk(_budgetBoxName);
    await Hive.deleteBoxFromDisk(_categoryBoxName);
    await Hive.deleteBoxFromDisk(_userBoxName);
    await Hive.deleteBoxFromDisk(_recurringBoxName);
    await Hive.deleteBoxFromDisk(_currencyBoxName);
    await Hive.deleteBoxFromDisk(_settingsBoxName);
    await Hive.deleteBoxFromDisk(_languageBoxName); // Add this
  }
}
