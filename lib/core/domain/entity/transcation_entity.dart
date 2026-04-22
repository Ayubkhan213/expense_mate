import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/domain/entity/transcation_item_entity.dart';

class TransactionEntity {
  final String id;
  final String? userId;
  final TransactionType type;
  final List<TransactionItemEntity> items;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final DateTime date;
  final bool isDebt;
  final String? debtId;
  final List<String>? tags;
  final String? attachmentPath;
  final bool isRecurring;
  final String? budgetId;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionEntity({
    required this.id,
    this.userId,
    required this.type,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.date,
    this.isDebt = false,
    this.debtId,
    this.tags,
    this.attachmentPath,
    this.isRecurring = false,
    this.budgetId,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  TransactionEntity copyWith({
    bool? isDeleted,
    String? budgetId,
    DateTime? updatedAt,
  }) => TransactionEntity(
    id: id,
    userId: userId,
    type: type,
    items: items,
    totalAmount: totalAmount,
    paymentMethod: paymentMethod,
    date: date,
    isDebt: isDebt,
    debtId: debtId,
    tags: tags,
    attachmentPath: attachmentPath,
    isRecurring: isRecurring,
    budgetId: budgetId ?? this.budgetId,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
