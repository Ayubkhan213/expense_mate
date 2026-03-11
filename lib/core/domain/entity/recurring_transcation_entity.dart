enum TransactionType { income, expense }

enum PaymentMethod { cash, card, bank, wallet }

enum RecurrenceFrequency { daily, weekly, biweekly, monthly, quarterly, yearly }

class RecurringTransactionEntity {
  final String id;
  final String? userId;
  final String categoryKey;
  final double amount;
  final String? note;
  final RecurrenceFrequency frequency;
  final TransactionType type;
  final PaymentMethod paymentMethod;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime nextOccurrence;
  final List<String> generatedTransactionIds;
  final bool isActive;
  final int dayOfMonth;
  final int? dayOfWeek;
  final DateTime createdAt;

  const RecurringTransactionEntity({
    required this.id,
    this.userId,
    required this.categoryKey,
    required this.amount,
    this.note,
    required this.frequency,
    required this.type,
    required this.paymentMethod,
    required this.startDate,
    this.endDate,
    required this.nextOccurrence,
    this.generatedTransactionIds = const [],
    this.isActive = true,
    this.dayOfMonth = 1,
    this.dayOfWeek,
    required this.createdAt,
  });

  bool get hasEnded => endDate != null && DateTime.now().isAfter(endDate!);
  bool get isDue => DateTime.now().isAfter(nextOccurrence);

  RecurringTransactionEntity copyWith({
    DateTime? nextOccurrence,
    List<String>? generatedTransactionIds,
    bool? isActive,
  }) => RecurringTransactionEntity(
    id: id,
    userId: userId,
    categoryKey: categoryKey,
    amount: amount,
    note: note,
    frequency: frequency,
    type: type,
    paymentMethod: paymentMethod,
    startDate: startDate,
    endDate: endDate,
    nextOccurrence: nextOccurrence ?? this.nextOccurrence,
    generatedTransactionIds:
        generatedTransactionIds ?? this.generatedTransactionIds,
    isActive: isActive ?? this.isActive,
    dayOfMonth: dayOfMonth,
    dayOfWeek: dayOfWeek,
    createdAt: createdAt,
  );
}
