import 'package:hive/hive.dart';
import 'transaction_item_model.dart';
import 'enums.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final TransactionType type; // income / expense

  @HiveField(2)
  final List<TransactionItem> items;

  @HiveField(3)
  final double totalAmount;

  @HiveField(4)
  final PaymentMethod paymentMethod;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final bool isDebt;

  @HiveField(7)
  final String? debtId; // reference to DebtModel.id

  @HiveField(8)
  final List<String>? tags;

  @HiveField(9)
  final String? attachmentPath;

  @HiveField(10)
  final bool isRecurring;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final bool isDeleted;

  @HiveField(14)
  final String? budgetId;

  @HiveField(15)
  final String? userId;

  TransactionModel({
    required this.id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isDeleted = false,
    this.budgetId,
    this.userId,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
