import 'package:hive/hive.dart';
import 'enums.dart';

part 'debt_model.g.dart';

@HiveType(typeId: 3)
class DebtModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String transactionId; // Initial transaction when debt was created

  @HiveField(2)
  final String personName;

  @HiveField(3)
  final double totalAmount; // Original debt amount

  @HiveField(4)
  final DebtType debtType; // borrowed / lent

  @HiveField(5)
  final DateTime expectedReturnDate;

  @HiveField(6)
  bool isReturned; // Fully settled

  @HiveField(7)
  final List<String> paymentIds; // Links to DebtPaymentModel ids

  @HiveField(8)
  double paidAmount; // Total paid so far

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  final String? personPhone; // Contact info

  @HiveField(12)
  final String? personImage; // Profile picture path

  DebtModel({
    required this.id,
    required this.transactionId,
    required this.personName,
    required this.totalAmount,
    required this.debtType,
    required this.expectedReturnDate,
    this.isReturned = false,
    this.paymentIds = const [],
    this.paidAmount = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.personPhone,
    this.personImage,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Helper methods
  double get remainingAmount => totalAmount - paidAmount;
  double get paymentPercentage =>
      (paidAmount / totalAmount * 100).clamp(0, 100);
  bool get isFullyPaid => paidAmount >= totalAmount;
  bool get isOverdue =>
      DateTime.now().isAfter(expectedReturnDate) && !isReturned;
  int get daysOverdue =>
      isOverdue ? DateTime.now().difference(expectedReturnDate).inDays : 0;
  int get daysUntilDue => expectedReturnDate.difference(DateTime.now()).inDays;
}
