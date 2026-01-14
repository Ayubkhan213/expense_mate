import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';

class CategoryBottomSheetState extends Equatable {
  final String display;
  final String currentNumber;
  final String operation;
  final double firstOperand;
  final File? selectedImage;
  final DateTime selectedDateTime;
  final String note;
  final CategoryHiveModel category;
  final TransactionType transactionType;
  final bool isDebt;
  final DebtType? debtType;
  final String? personName;
  final DateTime? expectedReturnDate;
  final PaymentMethod paymentMethod;

  const CategoryBottomSheetState({
    required this.display,
    required this.currentNumber,
    required this.operation,
    required this.firstOperand,
    required this.selectedImage,
    required this.selectedDateTime,
    required this.note,
    required this.category,
    required this.transactionType,
    this.isDebt = false,
    this.debtType,
    this.personName,
    this.expectedReturnDate,
    required this.paymentMethod,
  });

  factory CategoryBottomSheetState.initial(CategoryHiveModel category) {
    return CategoryBottomSheetState(
      display: '0',
      currentNumber: '',
      operation: '',
      firstOperand: 0,
      selectedImage: null,
      selectedDateTime: DateTime.now(),
      note: '',
      category: category,
      transactionType: category.isIncome
          ? TransactionType.income
          : TransactionType.expense,
      isDebt: false,
      debtType: null,
      personName: null,
      expectedReturnDate: null,
      paymentMethod: PaymentMethod.cash,
    );
  }

  CategoryBottomSheetState copyWith({
    String? display,
    String? currentNumber,
    String? operation,
    double? firstOperand,
    File? selectedImage,
    DateTime? selectedDateTime,
    String? note,
    CategoryHiveModel? category,
    TransactionType? transactionType,
    bool? isDebt,
    DebtType? debtType,
    bool clearDebtType = false,
    String? personName,
    bool clearPersonName = false,
    DateTime? expectedReturnDate,
    bool clearExpectedReturnDate = false,
    PaymentMethod? paymentMethod,
  }) {
    return CategoryBottomSheetState(
      display: display ?? this.display,
      currentNumber: currentNumber ?? this.currentNumber,
      operation: operation ?? this.operation,
      firstOperand: firstOperand ?? this.firstOperand,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      note: note ?? this.note,
      category: category ?? this.category,
      transactionType: transactionType ?? this.transactionType,
      isDebt: isDebt ?? this.isDebt,
      debtType: clearDebtType ? null : (debtType ?? this.debtType),
      personName: clearPersonName ? null : (personName ?? this.personName),
      expectedReturnDate: clearExpectedReturnDate
          ? null
          : (expectedReturnDate ?? this.expectedReturnDate),
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
    display,
    currentNumber,
    operation,
    firstOperand,
    selectedImage,
    selectedDateTime,
    note,
    category,
    transactionType,
    isDebt,
    debtType,
    personName,
    expectedReturnDate,
    paymentMethod,
  ];
}
