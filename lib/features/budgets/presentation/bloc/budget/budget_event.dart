import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgetsEvent extends BudgetEvent {}

class CreateBudgetEvent extends BudgetEvent {
  final String name;
  final dynamic type;
  final double totalAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String? category;
  final String icon;
  final int colorCode;

  const CreateBudgetEvent({
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
    this.category,
    required this.icon,
    required this.colorCode,
  });

  @override
  List<Object?> get props => [
    name,
    type,
    totalAmount,
    startDate,
    endDate,
    category,
    icon,
    colorCode,
  ];
}

class UpdateBudgetEvent extends BudgetEvent {
  final String budgetId;
  final String? name;
  final double? totalAmount;
  final bool? isActive;
  final bool? isArchived;

  const UpdateBudgetEvent({
    required this.budgetId,
    this.name,
    this.totalAmount,
    this.isActive,
    this.isArchived,
  });

  @override
  List<Object?> get props => [
    budgetId,
    name,
    totalAmount,
    isActive,
    isArchived,
  ];
}

class DeleteBudgetEvent extends BudgetEvent {
  final String budgetId;
  const DeleteBudgetEvent(this.budgetId);
  @override
  List<Object?> get props => [budgetId];
}

enum BudgetFilter { all, active, expired, archived } // ← all is FIRST now

class BudgetFilterChanged extends BudgetEvent {
  final BudgetFilter filter;
  const BudgetFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

// ── Search events ──
class BudgetSearchOpened extends BudgetEvent {}

class BudgetSearchClosed extends BudgetEvent {}

class BudgetSearchChanged extends BudgetEvent {
  final String query;
  const BudgetSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
