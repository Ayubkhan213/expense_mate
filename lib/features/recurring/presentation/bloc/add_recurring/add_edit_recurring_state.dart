import 'package:expense_mate/core/data/models/enums.dart';

enum RecurringFormStatus { initial, loading, success, error }

class AddEditRecurringState {
  final String recurringId; // null for add, id for edit
  final TransactionType transactionType;
  final String amount;
  final String categoryKey;
  final RecurrenceFrequency frequency;
  final PaymentMethod paymentMethod;
  final DateTime startDate;
  final DateTime? endDate;
  final int dayOfMonth;
  final int? dayOfWeek;
  final String note;
  final RecurringFormStatus status;
  final String? errorMessage;
  final String currentNumber;
  final String previousNumber;
  final String operation;

  AddEditRecurringState({
    this.recurringId = '',
    this.transactionType = TransactionType.expense,
    this.amount = '',
    this.categoryKey = 'rent',
    this.frequency = RecurrenceFrequency.monthly,
    this.paymentMethod = PaymentMethod.cash,
    DateTime? startDate,
    this.endDate,
    int? dayOfMonth,
    this.dayOfWeek,
    this.note = '',
    this.currentNumber = '',
    this.previousNumber = '',
    this.operation = '',
    this.status = RecurringFormStatus.initial,
    this.errorMessage,
  }) : startDate = startDate ?? DateTime.now(),
       dayOfMonth = dayOfMonth ?? DateTime.now().day;

  bool get isValid {
    final amountValue = double.tryParse(amount);
    return amountValue != null && amountValue > 0;
  }

  AddEditRecurringState copyWith({
    String? recurringId,
    TransactionType? transactionType,
    String? amount,
    String? categoryKey,
    RecurrenceFrequency? frequency,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    int? dayOfMonth,
    int? dayOfWeek,
    String? note,
    RecurringFormStatus? status,
    String? errorMessage,
    String? currentNumber,
    String? previousNumber,
    String? operation,
  }) {
    return AddEditRecurringState(
      recurringId: recurringId ?? this.recurringId,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      categoryKey: categoryKey ?? this.categoryKey,
      frequency: frequency ?? this.frequency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      note: note ?? this.note,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentNumber: currentNumber ?? this.currentNumber,
      previousNumber: previousNumber ?? this.previousNumber,
      operation: operation ?? this.operation,
    );
  }
}
