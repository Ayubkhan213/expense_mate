import 'package:expense_mate/core/data/models/enums.dart';
import 'package:hive/hive.dart';

part 'debt_payment_model.g.dart';

@HiveType(typeId: 8)
class DebtPaymentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String debtId; // Links to DebtModel.id

  @HiveField(2)
  final double amount; // Payment amount

  @HiveField(3)
  final DateTime paymentDate;

  @HiveField(4)
  final String? note; // "Partial payment", "Full settlement"

  @HiveField(5)
  final PaymentMethod paymentMethod;

  @HiveField(6)
  final String? transactionId; // Optional: link to TransactionModel

  @HiveField(7)
  final DateTime createdAt;

  DebtPaymentModel({
    required this.id,
    required this.debtId,
    required this.amount,
    required this.paymentDate,
    this.note,
    required this.paymentMethod,
    this.transactionId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
