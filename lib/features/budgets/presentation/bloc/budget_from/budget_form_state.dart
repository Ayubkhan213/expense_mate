import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:spendio/core/utils/icon_mapper.dart';
import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/enums.dart';

class BudgetFormState extends Equatable {
  final BudgetType selectedType;
  final DateTime startDate;
  final DateTime endDate;
  final String? selectedCategory;
  final IconData selectedIcon;
  final Color selectedColor;
  final String displayName;
  final String name;
  final String amount;
  final String operation;
  final Map<BudgetType, List<String>> categoryPresets;
  final List<Color> colorOptions;
  final List<IconData> iconOptions;

  // ✅ Edit mode fields
  final String? editingBudgetId; // null = create, non-null = edit
  final double? lockedSpentAmount; // keep existing spent amount on edit

  const BudgetFormState({
    required this.selectedType,
    required this.startDate,
    required this.endDate,
    this.selectedCategory,
    this.displayName = '',
    required this.selectedIcon,
    required this.selectedColor,
    this.name = '',
    this.amount = '',
    this.operation = '',
    required this.categoryPresets,
    required this.colorOptions,
    required this.iconOptions,
    this.editingBudgetId,
    this.lockedSpentAmount,
  });

  // ✅ Is this form in edit mode?
  bool get isEditMode => editingBudgetId != null;

  factory BudgetFormState.initial({
    Map<BudgetType, List<String>>? categoryPresets,
    BudgetModel? existingBudget, // ✅ pre-fill from existing budget
  }) {
    final now = DateTime.now();

    final defaultColors = [
      const Color(0xFF1565C0),
      const Color(0xFF2E7D32),
      const Color(0xFFEF6C00),
      const Color(0xFF6A1B9A),
      const Color(0xFFD32F2F),
      const Color(0xFF00897B),
      const Color(0xFFE91E63),
      const Color(0xFFFFA726),
    ];

    final defaultIcons = [
      Icons.account_balance_wallet,
      Icons.shopping_bag,
      Icons.home,
      Icons.flight,
      Icons.restaurant,
      Icons.directions_car,
      Icons.favorite,
      Icons.school,
    ];

    final defaultPresets = {
      BudgetType.monthly: [
        'Groceries',
        'Transport',
        'Entertainment',
        'Bills',
        'Shopping',
      ],
      BudgetType.project: [
        'Wedding',
        'Vacation',
        'Home Renovation',
        'Education',
        'Car Purchase',
      ],
      BudgetType.custom: ['Custom Budget'],
    };

    // ✅ Pre-fill from existing budget if editing
    if (existingBudget != null) {
      final iconCode = existingBudget.icon != null
          ? int.tryParse(existingBudget.icon!)
          : null;
      final icon = IconMapper.getIcon(iconCode);

      final color = existingBudget.colorCode != null
          ? Color(existingBudget.colorCode!)
          : const Color(0xFF1565C0);

      return BudgetFormState(
        selectedType: existingBudget.type,
        startDate: existingBudget.startDate,
        endDate: existingBudget.endDate,
        selectedCategory: existingBudget.category,
        displayName: existingBudget.name,
        selectedIcon: icon,
        selectedColor: color,
        name: existingBudget.name,
        amount: existingBudget.totalAmount.toStringAsFixed(
          existingBudget.totalAmount.truncateToDouble() ==
                  existingBudget.totalAmount
              ? 0
              : 2,
        ),
        operation: '',
        categoryPresets: categoryPresets ?? defaultPresets,
        colorOptions: defaultColors,
        iconOptions: defaultIcons,
        editingBudgetId: existingBudget.id, // ✅ marks edit mode
        lockedSpentAmount: existingBudget.spentAmount,
      );
    }

    return BudgetFormState(
      selectedType: BudgetType.monthly,
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
      selectedIcon: Icons.account_balance_wallet,
      selectedColor: const Color(0xFF1565C0),
      amount: '',
      operation: '',
      categoryPresets: categoryPresets ?? defaultPresets,
      colorOptions: defaultColors,
      iconOptions: defaultIcons,
    );
  }

  int get durationInDays => endDate.difference(startDate).inDays;
  List<String> get currentCategories => categoryPresets[selectedType] ?? [];

  BudgetFormState copyWith({
    BudgetType? selectedType,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedCategory,
    IconData? selectedIcon,
    Color? selectedColor,
    String? name,
    String? amount,
    String? displayName,
    String? operation,
    bool clearCategory = false,
  }) {
    return BudgetFormState(
      selectedType: selectedType ?? this.selectedType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      selectedIcon: selectedIcon ?? this.selectedIcon,
      selectedColor: selectedColor ?? this.selectedColor,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      operation: operation ?? this.operation,
      categoryPresets: categoryPresets,
      colorOptions: colorOptions,
      iconOptions: iconOptions,
      editingBudgetId: editingBudgetId, // ✅ preserve edit mode
      lockedSpentAmount: lockedSpentAmount, // ✅ preserve spent amount
    );
  }

  @override
  List<Object?> get props => [
    selectedType,
    startDate,
    endDate,
    selectedCategory,
    selectedIcon,
    selectedColor,
    name,
    amount,
    operation,
    displayName,
    editingBudgetId,
  ];
}
