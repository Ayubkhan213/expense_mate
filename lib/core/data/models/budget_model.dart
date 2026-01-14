import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 4)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name; // "January Salary", "Wedding Budget"

  @HiveField(2)
  final BudgetType type; // monthly, project, custom

  @HiveField(3)
  final double totalAmount; // Initial budget amount

  @HiveField(4)
  final double spentAmount; // Calculated from linked transactions

  @HiveField(5)
  final DateTime startDate;

  @HiveField(6)
  final DateTime endDate;

  @HiveField(7)
  final List<String> transactionIds; // Link to TransactionModel

  @HiveField(8)
  final String? category; // Optional: "Personal", "Work", "Wedding"

  @HiveField(9)
  final String? icon; // Icon name for UI

  @HiveField(10)
  final int? colorCode; // Color for UI

  @HiveField(11)
  bool isActive;

  @HiveField(12)
  bool isArchived;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  DateTime updatedAt;
  @HiveField(15)
  final String? userId;

  BudgetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAmount,
    this.spentAmount = 0.0,
    required this.startDate,
    required this.endDate,
    this.transactionIds = const [],
    this.category,
    this.icon,
    this.colorCode,
    this.isActive = true,
    this.isArchived = false,
    DateTime? createdAt,
    this.userId,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Helpers
  double get remainingAmount => totalAmount - spentAmount;
  double get spentPercentage => (spentAmount / totalAmount * 100).clamp(0, 100);
  bool get isOverBudget => spentAmount > totalAmount;
  bool get isExpired => DateTime.now().isAfter(endDate);
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
}

// Add to enums.dart
@HiveType(typeId: 13)
enum BudgetType {
  @HiveField(0)
  monthly, // Recurring monthly budget (salary)

  @HiveField(1)
  project, // One-time project (wedding, vacation)

  @HiveField(2)
  custom, // Custom duration
}
