enum BudgetType { monthly, project, custom }

class BudgetEntity {
  final String id;
  final String? userId;
  final String name;
  final BudgetType type;
  final double totalAmount;
  final double spentAmount;
  final DateTime startDate;
  final DateTime endDate;
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
    this.category,
    this.icon,
    this.colorCode,
    this.isActive = true,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Computed helpers
  double get remainingAmount => totalAmount - spentAmount;
  double get spentPercentage => (spentAmount / totalAmount * 100).clamp(0, 100);
  bool get isOverBudget => spentAmount > totalAmount;
  bool get isExpired => DateTime.now().isAfter(endDate);
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;

  BudgetEntity copyWith({
    double? spentAmount,
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
    category: category,
    icon: icon,
    colorCode: colorCode,
    isActive: isActive ?? this.isActive,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
