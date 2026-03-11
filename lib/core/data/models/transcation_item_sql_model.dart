import 'package:expense_mate/core/domain/entity/transcation_item_entity.dart';

class TransactionItemModel extends TransactionItemEntity {
  const TransactionItemModel({
    super.id,
    required super.transactionId,
    required super.category,
    required super.amount,
    super.note,
  });

  factory TransactionItemModel.fromMap(Map<String, dynamic> map) =>
      TransactionItemModel(
        id: map['id'] as int?,
        transactionId: map['transaction_id'] as String,
        category: map['category'] as String,
        amount: (map['amount'] as num).toDouble(),
        note: map['note'] as String?,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'transaction_id': transactionId,
      'category': category,
      'amount': amount,
      'note': note,
    };
    if (id != null) m['id'] = id;
    return m;
  }

  factory TransactionItemModel.fromEntity(TransactionItemEntity e) =>
      TransactionItemModel(
        id: e.id,
        transactionId: e.transactionId,
        category: e.category,
        amount: e.amount,
        note: e.note,
      );
}
