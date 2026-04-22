/// ─────────────────────────────────────────────────────────────────────────────
/// DB Constants — single source of truth for every table name & column name.
/// ─────────────────────────────────────────────────────────────────────────────
class DbConstants {
  DbConstants._();

  // ── Meta ────────────────────────────────────────────────────────────────────
  static const String dbName = 'spendio.db';
  static const int dbVersion = 1;

  // ── Shared column names ──────────────────────────────────────────────────────
  static const String colId = 'id';
  static const String colUserId = 'user_id';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colIsActive = 'is_active';
  static const String colIsDeleted = 'is_deleted';

  // ════════════════════════════════════════════════════════════════════════════
  // USERS
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableUsers = 'users';

  static const String colUserName = 'name';
  static const String colUserEmail = 'email';
  static const String colUserPhone = 'phone_number';
  static const String colUserProfilePic = 'profile_picture_path';
  static const String colUserCurrency = 'currency';
  static const String colUserPasswordHash = 'password_hash';
  static const String colUserIsLoggedIn = 'is_logged_in';
  static const String colUserLastLoginAt = 'last_login_at';
  static const String colUserPin = 'pin';
  static const String colUserUseBiometric = 'use_biometric';
  static const String colUserSecurityQ1 = 'security_question_1';
  static const String colUserSecurityA1 = 'security_answer_1';
  static const String colUserSecurityQ2 = 'security_question_2';
  static const String colUserSecurityA2 = 'security_answer_2';
  static const String colUserRecoveryKeys = 'recovery_keys'; // JSON array

  // ════════════════════════════════════════════════════════════════════════════
  // CATEGORIES
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableCategories = 'categories';

  static const String colCategoryKey = 'category_key';
  static const String colCategoryIconCode = 'icon_code';
  static const String colCategoryColorValue = 'color_value';
  static const String colCategoryIsIncome = 'is_income';

  // ════════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableTransactions = 'transactions';

  static const String colTxnType = 'type'; // income | expense
  static const String colTxnTotalAmount = 'total_amount';
  static const String colTxnPaymentMethod = 'payment_method';
  static const String colTxnDate = 'date';
  static const String colTxnIsDebt = 'is_debt';
  static const String colTxnDebtId = 'debt_id';
  static const String colTxnTags = 'tags'; // JSON array
  static const String colTxnAttachmentPath = 'attachment_path';
  static const String colTxnIsRecurring = 'is_recurring';
  static const String colTxnBudgetId = 'budget_id';

  // ════════════════════════════════════════════════════════════════════════════
  // TRANSACTION ITEMS
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableTransactionItems = 'transaction_items';

  static const String colTxnItemTransactionId = 'transaction_id';
  static const String colTxnItemCategory = 'category';
  static const String colTxnItemAmount = 'amount';
  static const String colTxnItemNote = 'note';

  // ════════════════════════════════════════════════════════════════════════════
  // BUDGETS
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableBudgets = 'budgets';

  static const String colBudgetName = 'name';
  static const String colBudgetType = 'type'; // monthly | project | custom
  static const String colBudgetTotalAmount = 'total_amount';
  static const String colBudgetSpentAmount = 'spent_amount';
  static const String colBudgetStartDate = 'start_date';
  static const String colBudgetEndDate = 'end_date';
  static const String colBudgetCategory = 'category';
  static const String colBudgetIcon = 'icon';
  static const String colBudgetColorCode = 'color_code';
  static const String colBudgetIsArchived = 'is_archived';

  // ════════════════════════════════════════════════════════════════════════════
  // DEBTS
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableDebts = 'debts';

  static const String colDebtTransactionId = 'transaction_id';
  static const String colDebtPersonName = 'person_name';
  static const String colDebtTotalAmount = 'total_amount';
  static const String colDebtType = 'debt_type'; // borrowed | lent
  static const String colDebtExpectedReturnDate = 'expected_return_date';
  static const String colDebtIsReturned = 'is_returned';
  static const String colDebtPaidAmount = 'paid_amount';
  static const String colDebtPersonPhone = 'person_phone';
  static const String colDebtPersonImage = 'person_image';

  // ════════════════════════════════════════════════════════════════════════════
  // DEBT PAYMENTS
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableDebtPayments = 'debt_payments';

  static const String colDebtPaymentDebtId = 'debt_id';
  static const String colDebtPaymentAmount = 'amount';
  static const String colDebtPaymentDate = 'payment_date';
  static const String colDebtPaymentNote = 'note';
  static const String colDebtPaymentMethod = 'payment_method';
  static const String colDebtPaymentTransactionId = 'transaction_id';

  // ════════════════════════════════════════════════════════════════════════════
  // RECURRING TRANSACTIONS
  // ════════════════════════════════════════════════════════════════════════════
  static const String tableRecurringTransactions = 'recurring_transactions';

  static const String colRecurringCategoryKey = 'category_key';
  static const String colRecurringAmount = 'amount';
  static const String colRecurringNote = 'note';
  static const String colRecurringFrequency = 'frequency';
  static const String colRecurringType = 'type'; // income | expense
  static const String colRecurringPaymentMethod = 'payment_method';
  static const String colRecurringStartDate = 'start_date';
  static const String colRecurringEndDate = 'end_date';
  static const String colRecurringNextOccurrence = 'next_occurrence';
  static const String colRecurringGeneratedIds =
      'generated_transaction_ids'; // JSON
  static const String colRecurringDayOfMonth = 'day_of_month';
  static const String colRecurringDayOfWeek = 'day_of_week';

  static const String tableCurrencies = 'currencies';
  static const String colCurrencyCode = 'code';
  static const String colCurrencyName = 'name';
  static const String colCurrencySymbol = 'symbol';
  static const String colCurrencyFlag = 'flag';
}
