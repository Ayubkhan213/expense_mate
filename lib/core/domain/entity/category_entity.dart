import 'package:flutter/material.dart';
import 'package:spendio/core/utils/icon_mapper.dart';

class CategoryEntity {
  final int? id;
  final String? userId;
  final String key;
  final int iconCode;
  final int colorValue;
  final bool isIncome;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    this.id,
    this.userId,
    required this.key,
    required this.iconCode,
    required this.colorValue,
    required this.isIncome,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Computed helpers available at domain level
  IconData get icon => IconMapper.getIcon(iconCode);
  Color get color => Color(colorValue);

  CategoryEntity copyWith({bool? isActive, DateTime? updatedAt}) =>
      CategoryEntity(
        id: id,
        userId: userId,
        key: key,
        iconCode: iconCode,
        colorValue: colorValue,
        isIncome: isIncome,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
