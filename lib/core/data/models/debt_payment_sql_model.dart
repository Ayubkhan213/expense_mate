import 'package:expense_mate/core/domain/entity/debt_payment_entity.dart';

class DebtPaymentModel extends DebtPaymentEntity {
  const DebtPaymentModel({
    required super.id,
    required super.debtId,
    required super.amount,
    required super.paymentDate,
    super.note,
    required super.paymentMethod,
    super.transactionId,
    required super.createdAt,
  });

  factory DebtPaymentModel.fromMap(Map<String, dynamic> map) =>
      DebtPaymentModel(
        id: map['id'] as String,
        debtId: map['debt_id'] as String,
        amount: (map['amount'] as num).toDouble(),
        paymentDate: DateTime.parse(map['payment_date'] as String),
        note: map['note'] as String?,
        paymentMethod: PaymentMethod.values.firstWhere(
          (p) => p.name == map['payment_method'],
        ),
        transactionId: map['transaction_id'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'debt_id': debtId,
    'amount': amount,
    'payment_date': paymentDate.toIso8601String(),
    'note': note,
    'payment_method': paymentMethod.name,
    'transaction_id': transactionId,
    'created_at': createdAt.toIso8601String(),
  };

  factory DebtPaymentModel.fromEntity(DebtPaymentEntity e) => DebtPaymentModel(
    id: e.id,
    debtId: e.debtId,
    amount: e.amount,
    paymentDate: e.paymentDate,
    note: e.note,
    paymentMethod: e.paymentMethod,
    transactionId: e.transactionId,
    createdAt: e.createdAt,
  );
}
