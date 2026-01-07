import 'dart:io';

import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/features/add_record/presentation/components/category_section/components/category_grid/components/category_bottom_sheet/bloc/category_bottom_sheet_event.dart';
import 'package:expense_mate/features/add_record/presentation/components/category_section/components/category_grid/components/category_bottom_sheet/bloc/category_bottom_sheet_state.dart';

import 'package:image_picker/image_picker.dart';

class CategoryBottomSheetBloc
    extends Bloc<CategoryBottomSheetEvent, CategoryBottomSheetState> {
  CategoryBottomSheetBloc({required CategoryHiveModel category})
    : super(CategoryBottomSheetState.initial(category)) {
    on<NumberPressed>((event, emit) {
      String display = state.display == '0'
          ? event.number
          : state.display + event.number;
      String currentNumber = state.currentNumber + event.number;
      emit(state.copyWith(display: display, currentNumber: currentNumber));
    });

    on<OperationPressed>((event, emit) {
      if (state.currentNumber.isEmpty) return;

      emit(
        state.copyWith(
          firstOperand: double.parse(state.currentNumber),
          operation: event.operation,
          currentNumber: '',
          display: '${state.display} ${event.operation}',
        ),
      );
    });

    on<EqualsPressed>((event, emit) {
      if (state.currentNumber.isEmpty || state.operation.isEmpty) return;

      double secondOperand = double.parse(state.currentNumber);
      double result = 0;

      switch (state.operation) {
        case '+':
          result = state.firstOperand + secondOperand;
          break;
        case '-':
          result = state.firstOperand - secondOperand;
          break;
        case '*':
          result = state.firstOperand * secondOperand;
          break;
        case '/':
          result = secondOperand != 0 ? state.firstOperand / secondOperand : 0;
          break;
      }

      emit(
        state.copyWith(
          display: result.toString(),
          currentNumber: result.toString(),
          operation: '',
        ),
      );
    });
    on<DebtCleared>((event, emit) {
      emit(state.copyWith(isDebt: false, debtType: null));
    });

    on<ClearPressed>((event, emit) {
      emit(
        state.copyWith(
          display: '0',
          currentNumber: '',
          operation: '',
          firstOperand: 0,
        ),
      );
    });

    on<DatePressed>((event, emit) async {
      final pickedDate = await showDatePicker(
        context: event.context,
        initialDate: state.selectedDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        // final pickedTime = await showTimePicker(
        //   context: event.context,
        //   initialTime: TimeOfDay.fromDateTime(state.selectedDateTime),
        // );

        // if (pickedTime != null) {
        //   final newDateTime = DateTime(
        //     pickedDate.year,
        //     pickedDate.month,
        //     pickedDate.day,
        //     pickedTime.hour,
        //     pickedTime.minute,
        //   );

        emit(
          state.copyWith(
            selectedDateTime: pickedDate,
            // display: DateFormat('dd/MM/yyyy HH:mm').format(newDateTime),
          ),
        );
      }
      // }
    });

    on<ImagePicked>((event, emit) async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        emit(state.copyWith(selectedImage: File(pickedFile.path)));
      }
    });

    on<NoteChanged>((event, emit) {
      emit(state.copyWith(note: event.note));
    });
    // Add these handlers to CategoryBottomSheetBloc

    on<PersonNameChanged>((event, emit) {
      emit(state.copyWith(personName: event.name));
    });

    on<ExpectedReturnDatePressed>((event, emit) async {
      final pickedDate = await showDatePicker(
        context: event.context,
        initialDate:
            state.expectedReturnDate ?? DateTime.now().add(Duration(days: 7)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        emit(state.copyWith(expectedReturnDate: pickedDate));
      }
    });

    // Update DebtToggled to clear debt fields when deselecting
    on<DebtToggled>((event, emit) {
      if (state.transactionType == TransactionType.expense &&
          event.type != DebtType.borrowed)
        return;

      if (state.transactionType == TransactionType.income &&
          event.type != DebtType.lent)
        return;

      final isSameSelection = state.debtType == event.type;

      if (isSameSelection) {
        // Deselect and clear all debt-related fields
        emit(
          state.copyWith(
            isDebt: false,
            clearDebtType: true,
            clearPersonName: true,
            clearExpectedReturnDate: true,
          ),
        );
      } else {
        // Select
        emit(state.copyWith(isDebt: true, debtType: event.type));
      }
    });
    on<PaymentMethodChanged>((event, emit) {
      emit(state.copyWith(paymentMethod: event.paymentMethod));
    });
  }
}
