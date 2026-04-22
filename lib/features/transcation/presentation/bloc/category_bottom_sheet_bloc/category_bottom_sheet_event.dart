import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';

abstract class CategoryBottomSheetEvent extends Equatable {
  const CategoryBottomSheetEvent();
  @override
  List<Object?> get props => [];
}

class NumberPressed extends CategoryBottomSheetEvent {
  final String number;
  const NumberPressed({required this.number});
}

class DebtCleared extends CategoryBottomSheetEvent {}

class OperationPressed extends CategoryBottomSheetEvent {
  final String operation;
  const OperationPressed({required this.operation});
}

class EqualsPressed extends CategoryBottomSheetEvent {}

class ClearPressed extends CategoryBottomSheetEvent {}

class DatePressed extends CategoryBottomSheetEvent {
  final dynamic context;
  const DatePressed(this.context);
}

class ImagePicked extends CategoryBottomSheetEvent {}

class ImagePickedFromCamera extends CategoryBottomSheetEvent {}

class ImageRemoved extends CategoryBottomSheetEvent {}

class NoteChanged extends CategoryBottomSheetEvent {
  final String note;
  const NoteChanged({required this.note});
}

class DebtToggled extends CategoryBottomSheetEvent {
  final DebtType type;
  const DebtToggled(this.type);
}

class PersonNameChanged extends CategoryBottomSheetEvent {
  final String name;
  const PersonNameChanged({required this.name});
}

class ExpectedReturnDatePressed extends CategoryBottomSheetEvent {
  final BuildContext context;
  const ExpectedReturnDatePressed(this.context);
}

class PaymentMethodChanged extends CategoryBottomSheetEvent {
  final PaymentMethod paymentMethod;
  const PaymentMethodChanged(this.paymentMethod);
}

class SaveBudgetTransaction extends CategoryBottomSheetEvent {
  final BudgetModel budgetModel;
  const SaveBudgetTransaction({required this.budgetModel});
}

class SaveNormalTransaction extends CategoryBottomSheetEvent {
  const SaveNormalTransaction();
}

class SaveDebtTransaction extends CategoryBottomSheetEvent {
  const SaveDebtTransaction();
}

class SaveDebtPayment extends CategoryBottomSheetEvent {
  final DebtModel debtModel;
  const SaveDebtPayment({required this.debtModel});
}

//  NEW — update existing transaction
class UpdateTransaction extends CategoryBottomSheetEvent {
  final TransactionModel existingTransaction;
  const UpdateTransaction({required this.existingTransaction});
}

class ResetTransactionStatus extends CategoryBottomSheetEvent {}

class PreFillDate extends CategoryBottomSheetEvent {
  final DateTime date;
  const PreFillDate(this.date);
}
