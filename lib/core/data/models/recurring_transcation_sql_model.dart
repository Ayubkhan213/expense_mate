import 'dart:convert';

import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/domain/entity/recurring_transcation_entity.dart';

class RecurringTransactionModel extends RecurringTransactionEntity {
  const RecurringTransactionModel({
    required super.id,
    super.userId,
    required super.categoryKey,
    required super.amount,
    super.note,
    required super.frequency,
    required super.type,
    required super.paymentMethod,
    required super.startDate,
    super.endDate,
    required super.nextOccurrence,
    super.generatedTransactionIds,
    super.isActive,
    super.dayOfMonth,
    super.dayOfWeek,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RecurringTransactionModel.fromMap(Map<String, dynamic> map) =>
      RecurringTransactionModel(
        id: map['id'] as String,
        userId: map['user_id'] as String?,
        categoryKey: map['category_key'] as String,
        amount: (map['amount'] as num).toDouble(),
        note: map['note'] as String?,
        frequency: RecurrenceFrequency.values.firstWhere(
          (f) => f.name == map['frequency'],
        ),
        type: TransactionType.values.firstWhere((t) => t.name == map['type']),
        paymentMethod: PaymentMethod.values.firstWhere(
          (p) => p.name == map['payment_method'],
        ),
        startDate: DateTime.parse(map['start_date'] as String),
        endDate: map['end_date'] != null
            ? DateTime.parse(map['end_date'] as String)
            : null,
        nextOccurrence: DateTime.parse(map['next_occurrence'] as String),
        generatedTransactionIds: map['generated_transaction_ids'] != null
            ? List<String>.from(
                jsonDecode(map['generated_transaction_ids'] as String),
              )
            : const [],
        isActive: (map['is_active'] as int? ?? 1) == 1,
        dayOfMonth: map['day_of_month'] as int? ?? 1,
        dayOfWeek: map['day_of_week'] as int?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'category_key': categoryKey,
    'amount': amount,
    'note': note,
    'frequency': frequency.name,
    'type': type.name,
    'payment_method': paymentMethod.name,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'next_occurrence': nextOccurrence.toIso8601String(),
    'generated_transaction_ids': generatedTransactionIds.isNotEmpty
        ? jsonEncode(generatedTransactionIds)
        : null,
    'is_active': isActive ? 1 : 0,
    'day_of_month': dayOfMonth,
    'day_of_week': dayOfWeek,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory RecurringTransactionModel.fromEntity(RecurringTransactionEntity e) =>
      RecurringTransactionModel(
        id: e.id,
        userId: e.userId,
        categoryKey: e.categoryKey,
        amount: e.amount,
        note: e.note,
        frequency: e.frequency,
        type: e.type,
        paymentMethod: e.paymentMethod,
        startDate: e.startDate,
        endDate: e.endDate,
        nextOccurrence: e.nextOccurrence,
        generatedTransactionIds: e.generatedTransactionIds,
        isActive: e.isActive,
        dayOfMonth: e.dayOfMonth,
        dayOfWeek: e.dayOfWeek,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );
}
