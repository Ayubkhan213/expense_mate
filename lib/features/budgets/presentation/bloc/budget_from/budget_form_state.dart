import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';

class BudgetFormState extends Equatable {
  final BudgetType selectedType;
  final DateTime startDate;
  final DateTime endDate;
  final String? selectedCategory;
  final IconData selectedIcon;
  final Color selectedColor;
  final String name;
  final String amount; // ← NEW
  final String operation; // ← NEW ('+' | '-' | '')
  final Map<BudgetType, List<String>> categoryPresets;
  final List<Color> colorOptions;
  final List<IconData> iconOptions;

  const BudgetFormState({
    required this.selectedType,
    required this.startDate,
    required this.endDate,
    this.selectedCategory,
    required this.selectedIcon,
    required this.selectedColor,
    this.name = '',
    this.amount = '', // ← NEW
    this.operation = '', // ← NEW
    required this.categoryPresets,
    required this.colorOptions,
    required this.iconOptions,
  });

  factory BudgetFormState.initial({
    Map<BudgetType, List<String>>? categoryPresets,
  }) {
    final now = DateTime.now();
    return BudgetFormState(
      selectedType: BudgetType.monthly,
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
      selectedIcon: Icons.account_balance_wallet,
      selectedColor: const Color(0xFF1565C0),
      amount: '',
      operation: '',

      categoryPresets: {
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
      },
      colorOptions: [
        const Color(0xFF1565C0),
        const Color(0xFF2E7D32),
        const Color(0xFFEF6C00),
        const Color(0xFF6A1B9A),
        const Color(0xFFD32F2F),
        const Color(0xFF00897B),
        const Color(0xFFE91E63),
        const Color(0xFFFFA726),
      ],
      iconOptions: [
        Icons.account_balance_wallet,
        Icons.shopping_bag,
        Icons.home,
        Icons.flight,
        Icons.restaurant,
        Icons.directions_car,
        Icons.favorite,
        Icons.school,
      ],
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
      name: name ?? this.name,
      amount: amount ?? this.amount,
      operation: operation ?? this.operation,
      categoryPresets: categoryPresets,
      colorOptions: colorOptions,
      iconOptions: iconOptions,
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
  ];
}
