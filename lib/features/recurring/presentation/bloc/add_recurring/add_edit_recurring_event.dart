import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';

abstract class AddEditRecurringEvent {}

/// Initialize form with category and optional existing recurring
class InitializeForm extends AddEditRecurringEvent {
  final CategoryHiveModel category;
  final RecurringTransactionModel? existing;

  InitializeForm({required this.category, this.existing});
}

class TransactionTypeChanged extends AddEditRecurringEvent {
  final TransactionType type;
  TransactionTypeChanged(this.type);
}

class AmountChanged extends AddEditRecurringEvent {
  final String amount;
  AmountChanged(this.amount);
}

class CategoryChanged extends AddEditRecurringEvent {
  final String categoryKey;
  CategoryChanged(this.categoryKey);
}

class FrequencyChanged extends AddEditRecurringEvent {
  final RecurrenceFrequency frequency;
  FrequencyChanged(this.frequency);
}

class PaymentMethodChanged extends AddEditRecurringEvent {
  final PaymentMethod method;
  PaymentMethodChanged(this.method);
}

class StartDateChanged extends AddEditRecurringEvent {
  final DateTime date;
  StartDateChanged(this.date);
}

class EndDateChanged extends AddEditRecurringEvent {
  final DateTime? date;
  EndDateChanged(this.date);
}

class DayOfMonthChanged extends AddEditRecurringEvent {
  final int day;
  DayOfMonthChanged(this.day);
}

class NoteChanged extends AddEditRecurringEvent {
  final String note;
  NoteChanged(this.note);
}

class SubmitRecurring extends AddEditRecurringEvent {}

class ResetForm extends AddEditRecurringEvent {}

class CalculatorNumberPressed extends AddEditRecurringEvent {
  final String number;
  CalculatorNumberPressed(this.number);
}

class CalculatorOperationPressed extends AddEditRecurringEvent {
  final String operation;
  CalculatorOperationPressed(this.operation);
}

class CalculatorEqualsPressed extends AddEditRecurringEvent {}

class CalculatorClearPressed extends AddEditRecurringEvent {}
