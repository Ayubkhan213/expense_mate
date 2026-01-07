import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/enums.dart';

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

// Add this new event class
class PaymentMethodChanged extends CategoryBottomSheetEvent {
  final PaymentMethod paymentMethod;

  const PaymentMethodChanged(this.paymentMethod);
}
