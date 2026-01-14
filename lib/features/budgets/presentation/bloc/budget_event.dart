// Main Budget BLoC Events
import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/navigation_fram.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgetsEvent extends BudgetEvent {}

class CreateBudgetEvent extends BudgetEvent {
  final String name;
  final BudgetType type;
  final double totalAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String? category;
  final String? icon;
  final int? colorCode;

  const CreateBudgetEvent({
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
    this.category,
    this.icon,
    this.colorCode,
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
