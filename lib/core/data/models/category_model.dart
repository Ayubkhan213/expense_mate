import 'package:spendio/core/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    super.id,
    super.userId,
    required super.key,
    required super.iconCode,
    required super.colorValue,
    required super.isIncome,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
    id: map['id'] as int?,
    userId: map['user_id'] as String?,
    key: map['category_key'] as String,
    iconCode: map['icon_code'] as int,
    colorValue: map['color_value'] as int,
    isIncome: (map['is_income'] as int? ?? 0) == 1,
    isActive: (map['is_active'] as int? ?? 1) == 1,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'user_id': userId,
      'category_key': key,
      'icon_code': iconCode,
      'color_value': colorValue,
      'is_income': isIncome ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
    if (id != null) m['id'] = id;
    return m;
  }

  factory CategoryModel.fromEntity(CategoryEntity e) => CategoryModel(
    id: e.id,
    userId: e.userId,
    key: e.key,
    iconCode: e.iconCode,
    colorValue: e.colorValue,
    isIncome: e.isIncome,
    isActive: e.isActive,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );
}
