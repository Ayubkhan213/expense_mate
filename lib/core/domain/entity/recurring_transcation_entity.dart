import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/recurring_transcation_sql_model.dart';

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
  final DateTime updatedAt;

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
    required this.updatedAt,
  });

  bool get hasEnded => endDate != null && DateTime.now().isAfter(endDate!);
  bool get isDue => DateTime.now().isAfter(nextOccurrence);

  // Add this method to RecurringTransactionModel in recurring_transcation_sql_model.dart
  RecurringTransactionModel copyWith({
    String? id,
    String? userId,
    String? categoryKey,
    double? amount,
    String? note,
    RecurrenceFrequency? frequency,
    TransactionType? type,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextOccurrence,
    List<String>? generatedTransactionIds,
    bool? isActive,
    int? dayOfMonth,
    int? dayOfWeek,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurringTransactionModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    categoryKey: categoryKey ?? this.categoryKey,
    amount: amount ?? this.amount,
    note: note ?? this.note,
    frequency: frequency ?? this.frequency,
    type: type ?? this.type,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    nextOccurrence: nextOccurrence ?? this.nextOccurrence,
    generatedTransactionIds:
        generatedTransactionIds ?? this.generatedTransactionIds,
    isActive: isActive ?? this.isActive,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
