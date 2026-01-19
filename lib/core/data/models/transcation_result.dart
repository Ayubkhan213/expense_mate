class TransactionResult {
  final bool success;
  final String message;
  final String? transactionId;

  const TransactionResult({
    required this.success,
    required this.message,
    this.transactionId,
  });
}
