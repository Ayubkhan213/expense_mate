import 'package:spendio/core/data/models/enums.dart';

class BudgetEntity {
  final String id;
  final String? userId;
  final String name;
  final BudgetType type;
  final double totalAmount;
  final double spentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> transactionIds; // IDs of linked transactions
  final String? category;
  final String? icon;
  final int? colorCode;
  final bool isActive;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.type,
    required this.totalAmount,
    this.spentAmount = 0,
    required this.startDate,
    required this.endDate,
    this.transactionIds = const [],
    this.category,
    this.icon,
    this.colorCode,
    this.isActive = true,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── Computed helpers ───────────────────────────────────────────────────────
  double get remainingAmount => totalAmount - spentAmount;
  double get spentPercentage => (spentAmount / totalAmount * 100).clamp(0, 100);
  bool get isOverBudget => spentAmount > totalAmount;
  bool get isExpired => DateTime.now().isAfter(endDate);
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;

  BudgetEntity copyWith({
    double? spentAmount,
    List<String>? transactionIds,
    bool? isActive,
    bool? isArchived,
    DateTime? updatedAt,
  }) => BudgetEntity(
    id: id,
    userId: userId,
    name: name,
    type: type,
    totalAmount: totalAmount,
    spentAmount: spentAmount ?? this.spentAmount,
    startDate: startDate,
    endDate: endDate,
    transactionIds: transactionIds ?? this.transactionIds,
    category: category,
    icon: icon,
    colorCode: colorCode,
    isActive: isActive ?? this.isActive,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
