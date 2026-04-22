import 'dart:convert';

import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/domain/entity/budget_entity.dart';

class BudgetModel extends BudgetEntity {
  const BudgetModel({
    required super.id,
    super.userId,
    required super.name,
    required super.type,
    required super.totalAmount,
    super.spentAmount,
    required super.startDate,
    required super.endDate,
    super.transactionIds,
    super.category,
    super.icon,
    super.colorCode,
    super.isActive,
    super.isArchived,
    required super.createdAt,
    required super.updatedAt,
  });

  // ── DB row → Model ──────────────────────────────────────────────────────────
  // transactionIds is intentionally left empty here.
  // The datasource fills it by querying:
  //   SELECT id FROM transactions WHERE budget_id = ? AND is_deleted = 0
  factory BudgetModel.fromMap(
    Map<String, dynamic> map, {
    List<String> transactionIds = const [],
  }) => BudgetModel(
    id: map['id'] as String,
    userId: map['user_id'] as String?,
    name: map['name'] as String,
    type: BudgetType.values.firstWhere((t) => t.name == map['type']),
    totalAmount: (map['total_amount'] as num).toDouble(),
    spentAmount: (map['spent_amount'] as num?)?.toDouble() ?? 0,
    startDate: DateTime.parse(map['start_date'] as String),
    endDate: DateTime.parse(map['end_date'] as String),
    transactionIds: transactionIds,
    category: map['category'] as String?,
    icon: map['icon'] as String?,
    colorCode: map['color_code'] as int?,
    isActive: (map['is_active'] as int? ?? 1) == 1,
    isArchived: (map['is_archived'] as int? ?? 0) == 1,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  // ── Model → DB row ──────────────────────────────────────────────────────────
  // transactionIds is NOT written to the budgets table —
  // the reverse FK on transactions is the source of truth.
  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'type': type.name,
    'total_amount': totalAmount,
    'spent_amount': spentAmount,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'category': category,
    'icon': icon,
    'color_code': colorCode,
    'is_active': isActive ? 1 : 0,
    'is_archived': isArchived ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory BudgetModel.fromEntity(BudgetEntity e) => BudgetModel(
    id: e.id,
    userId: e.userId,
    name: e.name,
    type: e.type,
    totalAmount: e.totalAmount,
    spentAmount: e.spentAmount,
    startDate: e.startDate,
    endDate: e.endDate,
    transactionIds: e.transactionIds,
    category: e.category,
    icon: e.icon,
    colorCode: e.colorCode,
    isActive: e.isActive,
    isArchived: e.isArchived,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );
}
