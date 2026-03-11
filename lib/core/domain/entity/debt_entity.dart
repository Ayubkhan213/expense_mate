enum DebtType { borrowed, lent }

class DebtEntity {
  final String id;
  final String? userId;
  final String transactionId;
  final String personName;
  final double totalAmount;
  final DebtType debtType;
  final DateTime expectedReturnDate;
  final bool isReturned;
  final double paidAmount;
  final String? personPhone;
  final String? personImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DebtEntity({
    required this.id,
    this.userId,
    required this.transactionId,
    required this.personName,
    required this.totalAmount,
    required this.debtType,
    required this.expectedReturnDate,
    this.isReturned = false,
    this.paidAmount = 0,
    this.personPhone,
    this.personImage,
    required this.createdAt,
    required this.updatedAt,
  });

  // Computed helpers
  double get remainingAmount => totalAmount - paidAmount;
  double get paymentPercentage =>
      (paidAmount / totalAmount * 100).clamp(0, 100);
  bool get isFullyPaid => paidAmount >= totalAmount;
  bool get isOverdue =>
      DateTime.now().isAfter(expectedReturnDate) && !isReturned;
  int get daysOverdue =>
      isOverdue ? DateTime.now().difference(expectedReturnDate).inDays : 0;
  int get daysUntilDue => expectedReturnDate.difference(DateTime.now()).inDays;

  DebtEntity copyWith({
    bool? isReturned,
    double? paidAmount,
    DateTime? updatedAt,
  }) => DebtEntity(
    id: id,
    userId: userId,
    transactionId: transactionId,
    personName: personName,
    totalAmount: totalAmount,
    debtType: debtType,
    expectedReturnDate: expectedReturnDate,
    isReturned: isReturned ?? this.isReturned,
    paidAmount: paidAmount ?? this.paidAmount,
    personPhone: personPhone,
    personImage: personImage,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
