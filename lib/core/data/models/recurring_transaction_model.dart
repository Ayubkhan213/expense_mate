import 'package:hive/hive.dart';
import 'enums.dart';

part 'recurring_transaction_model.g.dart';

@HiveType(typeId: 7)
class RecurringTransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryKey; // "salary", "rent", etc.

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final RecurrenceFrequency frequency;

  @HiveField(5)
  final TransactionType type; // income / expense

  @HiveField(6)
  final PaymentMethod paymentMethod;

  @HiveField(7)
  final DateTime startDate;

  @HiveField(8)
  final DateTime? endDate; // null = indefinite

  @HiveField(9)
  DateTime nextOccurrence;

  @HiveField(10)
  final List<String> generatedTransactionIds; // Track created transactions

  @HiveField(11)
  bool isActive;

  @HiveField(12)
  final int dayOfMonth; // For monthly: 1-31

  @HiveField(13)
  final int? dayOfWeek; // For weekly: 1=Monday, 7=Sunday

  @HiveField(14)
  final DateTime createdAt;

  RecurringTransactionModel({
    required this.id,
    required this.categoryKey,
    required this.amount,
    this.note,
    required this.frequency,
    required this.type,
    required this.paymentMethod,
    required this.startDate,
    this.endDate,
    required this.nextOccurrence,
    this.generatedTransactionIds = const [],
    this.isActive = true,
    this.dayOfMonth = 1,
    this.dayOfWeek,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get hasEnded => endDate != null && DateTime.now().isAfter(endDate!);
  bool get isDue => DateTime.now().isAfter(nextOccurrence);
}
