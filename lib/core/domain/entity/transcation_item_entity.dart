class TransactionItemEntity {
  final int? id;
  final String transactionId;
  final String category;
  final double amount;
  final String? note;

  const TransactionItemEntity({
    this.id,
    required this.transactionId,
    required this.category,
    required this.amount,
    this.note,
  });
}
