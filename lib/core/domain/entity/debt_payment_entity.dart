import 'package:spendio/core/data/models/enums.dart';

class DebtPaymentEntity {
  final String id;
  final String debtId;
  final double amount;
  final DateTime paymentDate;
  final String? note;
  final PaymentMethod paymentMethod;
  final String? transactionId;
  final DateTime createdAt;

  const DebtPaymentEntity({
    required this.id,
    required this.debtId,
    required this.amount,
    required this.paymentDate,
    this.note,
    required this.paymentMethod,
    this.transactionId,
    required this.createdAt,
  });
}
