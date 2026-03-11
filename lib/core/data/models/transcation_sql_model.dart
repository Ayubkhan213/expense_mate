import 'dart:convert';

import 'package:expense_mate/core/domain/entity/transcation_entity.dart';
import 'package:expense_mate/core/domain/entity/transcation_item_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    super.userId,
    required super.type,
    required super.items,
    required super.totalAmount,
    required super.paymentMethod,
    required super.date,
    super.isDebt,
    super.debtId,
    super.tags,
    super.attachmentPath,
    super.isRecurring,
    super.budgetId,
    super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Converts the flat `transactions` table row into a TransactionModel.
  /// Pass the already-fetched [items] from the `transaction_items` table.
  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
    List<TransactionItemEntity> items,
  ) => TransactionModel(
    id: map['id'] as String,
    userId: map['user_id'] as String?,
    type: TransactionType.values.firstWhere((t) => t.name == map['type']),
    items: items,
    totalAmount: (map['total_amount'] as num).toDouble(),
    paymentMethod: PaymentMethod.values.firstWhere(
      (p) => p.name == map['payment_method'],
    ),
    date: DateTime.parse(map['date'] as String),
    isDebt: (map['is_debt'] as int? ?? 0) == 1,
    debtId: map['debt_id'] as String?,
    tags: map['tags'] != null
        ? List<String>.from(jsonDecode(map['tags'] as String))
        : null,
    attachmentPath: map['attachment_path'] as String?,
    isRecurring: (map['is_recurring'] as int? ?? 0) == 1,
    budgetId: map['budget_id'] as String?,
    isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  /// Converts this model into the flat map for the `transactions` table.
  /// Items must be saved separately via TransactionItemModel.toMap().
  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'type': type.name,
    'total_amount': totalAmount,
    'payment_method': paymentMethod.name,
    'date': date.toIso8601String(),
    'is_debt': isDebt ? 1 : 0,
    'debt_id': debtId,
    'tags': tags != null ? jsonEncode(tags) : null,
    'attachment_path': attachmentPath,
    'is_recurring': isRecurring ? 1 : 0,
    'budget_id': budgetId,
    'is_deleted': isDeleted ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory TransactionModel.fromEntity(TransactionEntity e) => TransactionModel(
    id: e.id,
    userId: e.userId,
    type: e.type,
    items: e.items,
    totalAmount: e.totalAmount,
    paymentMethod: e.paymentMethod,
    date: e.date,
    isDebt: e.isDebt,
    debtId: e.debtId,
    tags: e.tags,
    attachmentPath: e.attachmentPath,
    isRecurring: e.isRecurring,
    budgetId: e.budgetId,
    isDeleted: e.isDeleted,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );
}
