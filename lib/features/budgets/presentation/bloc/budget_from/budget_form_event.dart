import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/data/models/enums.dart';

abstract class BudgetFormEvent extends Equatable {
  const BudgetFormEvent();

  @override
  List<Object?> get props => [];
}

class BudgetFormTypeChanged extends BudgetFormEvent {
  final BudgetType type;
  const BudgetFormTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class BudgetFormCategorySelected extends BudgetFormEvent {
  final String category; // English key → stored in DB
  final String displayName; // Translated label → shown in UI
  const BudgetFormCategorySelected(this.category, this.displayName);
}

class BudgetFormColorChanged extends BudgetFormEvent {
  final Color color;
  const BudgetFormColorChanged(this.color);
  @override
  List<Object?> get props => [color];
}

class BudgetFormIconChanged extends BudgetFormEvent {
  final IconData icon;
  const BudgetFormIconChanged(this.icon);
  @override
  List<Object?> get props => [icon];
}

class BudgetFormStartDateChanged extends BudgetFormEvent {
  final DateTime date;
  const BudgetFormStartDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class BudgetFormEndDateChanged extends BudgetFormEvent {
  final DateTime date;
  const BudgetFormEndDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class BudgetFormNameChanged extends BudgetFormEvent {
  final String name;
  const BudgetFormNameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

// ── NEW ──
class BudgetFormAmountChanged extends BudgetFormEvent {
  final String amount;
  const BudgetFormAmountChanged(this.amount);
  @override
  List<Object?> get props => [amount];
}

class BudgetFormOperationChanged extends BudgetFormEvent {
  final String operation;
  const BudgetFormOperationChanged(this.operation);
  @override
  List<Object?> get props => [operation];
}
// ────────

class BudgetFormReset extends BudgetFormEvent {}
