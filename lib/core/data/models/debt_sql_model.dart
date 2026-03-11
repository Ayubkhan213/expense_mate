import 'package:expense_mate/core/domain/entity/debt_entity.dart';

class DebtModel extends DebtEntity {
  const DebtModel({
    required super.id,
    super.userId,
    required super.transactionId,
    required super.personName,
    required super.totalAmount,
    required super.debtType,
    required super.expectedReturnDate,
    super.isReturned,
    super.paidAmount,
    super.personPhone,
    super.personImage,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DebtModel.fromMap(Map<String, dynamic> map) => DebtModel(
    id: map['id'] as String,
    userId: map['user_id'] as String?,
    transactionId: map['transaction_id'] as String,
    personName: map['person_name'] as String,
    totalAmount: (map['total_amount'] as num).toDouble(),
    debtType: DebtType.values.firstWhere((t) => t.name == map['debt_type']),
    expectedReturnDate: DateTime.parse(map['expected_return_date'] as String),
    isReturned: (map['is_returned'] as int? ?? 0) == 1,
    paidAmount: (map['paid_amount'] as num?)?.toDouble() ?? 0,
    personPhone: map['person_phone'] as String?,
    personImage: map['person_image'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'transaction_id': transactionId,
    'person_name': personName,
    'total_amount': totalAmount,
    'debt_type': debtType.name,
    'expected_return_date': expectedReturnDate.toIso8601String(),
    'is_returned': isReturned ? 1 : 0,
    'paid_amount': paidAmount,
    'person_phone': personPhone,
    'person_image': personImage,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory DebtModel.fromEntity(DebtEntity e) => DebtModel(
    id: e.id,
    userId: e.userId,
    transactionId: e.transactionId,
    personName: e.personName,
    totalAmount: e.totalAmount,
    debtType: e.debtType,
    expectedReturnDate: e.expectedReturnDate,
    isReturned: e.isReturned,
    paidAmount: e.paidAmount,
    personPhone: e.personPhone,
    personImage: e.personImage,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );
}
