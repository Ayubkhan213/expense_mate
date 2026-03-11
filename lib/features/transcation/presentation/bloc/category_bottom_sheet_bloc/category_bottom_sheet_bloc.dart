import 'dart:io';

import 'package:expense_mate/core/app_export.dart';

import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_item_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/data/models/transcation_result.dart';
import 'package:expense_mate/core/domain/use_cases/add_debt_payment_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/add_debt_transcation_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/add_debt_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/add_transcation_usecase.dart';
import 'package:expense_mate/core/domain/use_cases/save_budget_transcation_usecase.dart';
import 'package:expense_mate/core/services/app_prefs.dart';
import 'package:expense_mate/features/transcation/presentation/bloc/category_bottom_sheet_bloc/category_bottom_sheet_event.dart';
import 'package:expense_mate/features/transcation/presentation/bloc/category_bottom_sheet_bloc/category_bottom_sheet_state.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CategoryBottomSheetBloc
    extends Bloc<CategoryBottomSheetEvent, CategoryBottomSheetState> {
  SaveBudgetTranscationUsecase saveBudgetTranscationUsecase;
  SaveNormalTranscationUsecase saveNormalTranscationUsecase;
  SaveDebtTranscationUsecase saveDebtTranscationUsecase;
  AddDebtPaymentUseCase addDebtPaymentUseCase;
  AddDebtUsecase addDebtUsecase;

  CategoryBottomSheetBloc({
    required CategoryHiveModel category,
    required this.saveBudgetTranscationUsecase,
    required this.addDebtUsecase,
    required this.addDebtPaymentUseCase,
    required this.saveNormalTranscationUsecase,
    required this.saveDebtTranscationUsecase,
  }) : super(CategoryBottomSheetState.initial(category)) {
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
        // Copy to app's permanent storage
        final appDir = await getApplicationDocumentsDirectory();
        final attachmentsDir = Directory('${appDir.path}/attachments');
        if (!await attachmentsDir.exists()) {
          await attachmentsDir.create(recursive: true);
        }
        final ext = pickedFile.path.split('.').last;
        final fileName = 'attachment_${const Uuid().v4()}.$ext';
        final savedFile = await File(
          pickedFile.path,
        ).copy('${attachmentsDir.path}/$fileName');
        emit(state.copyWith(selectedImage: savedFile));
      }
    });

    on<ImagePickedFromCamera>((event, emit) async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final attachmentsDir = Directory('${appDir.path}/attachments');
        if (!await attachmentsDir.exists()) {
          await attachmentsDir.create(recursive: true);
        }
        final ext = pickedFile.path.split('.').last;
        final fileName = 'attachment_${const Uuid().v4()}.$ext';
        final savedFile = await File(
          pickedFile.path,
        ).copy('${attachmentsDir.path}/$fileName');
        emit(state.copyWith(selectedImage: savedFile));
      }
    });
    on<NoteChanged>((event, emit) {
      emit(state.copyWith(note: event.note));
    });

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
    on<ImageRemoved>((event, emit) {
      emit(state.copyWith(clearSelectedImage: true));
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

    on<SaveBudgetTransaction>(_onSaveBudgetTransaction);
    on<SaveNormalTransaction>(_onSaveNormalTransaction);
    on<SaveDebtTransaction>(_onSaveDebtTransaction);
    on<SaveDebtPayment>(_onSaveDebtPayment);
    on<ResetTransactionStatus>(_onResetTransactionStatus);
  }
  void _onResetTransactionStatus(
    ResetTransactionStatus event,
    Emitter<CategoryBottomSheetState> emit,
  ) {
    emit(
      state.copyWith(
        transactionStatus: TransactionStatus.initial,
        errorMessage: '',
      ),
    );
  }

  Future<void> _onSaveBudgetTransaction(
    SaveBudgetTransaction event,
    Emitter<CategoryBottomSheetState> emit,
  ) async {
    try {
      // 1️ Validation
      if (double.parse(state.display) <= 0) {
        emit(
          state.copyWith(
            transactionStatus: TransactionStatus.error,
            errorMessage: 'Amount cannot be zero',
          ),
        );
        return;
      }

      // 2️ Create Transaction Item
      final item = TransactionItem(
        category: state.category.key,
        amount: double.parse(state.display),
        note: state.note,
      );

      // 3️ Create Transaction Model
      final transaction = TransactionModel(
        id: const Uuid().v4(),
        type: TransactionType.expense,
        items: [item],
        totalAmount: double.parse(state.display),
        paymentMethod: state.paymentMethod,
        date: state.selectedDateTime,
        isDebt: state.isDebt,
        debtId: null,
        attachmentPath: state.selectedImage?.path,
        budgetId: event.budgetModel.id,
        userId: AppPrefs.instance.userId,
      );

      // 4️ Call UseCase
      TransactionResult transactionResult = await saveBudgetTranscationUsecase(
        transaction: transaction,
        budget: event.budgetModel,
      );
      if (transactionResult.success) {
        // 5️ Emit Success
        emit(state.copyWith(transactionStatus: TransactionStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          transactionStatus: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _emitError(
    Emitter<CategoryBottomSheetState> emit,
    String message,
  ) async {
    emit(
      state.copyWith(
        transactionStatus: TransactionStatus.error,
        errorMessage: message,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(transactionStatus: TransactionStatus.initial));
  }

  Future<void> _onSaveNormalTransaction(
    SaveNormalTransaction event,
    Emitter<CategoryBottomSheetState> emit,
  ) async {
    try {
      // -------------------- 1️ VALIDATION --------------------
      final amount = double.tryParse(state.display) ?? 0;

      if (amount <= 0) {
        await _emitError(emit, 'Amount cannot be zero');
        return;
      }

      // -------------------- 2️ CREATE DEBT (ONLY IF NEEDED) --------------------
      // String? debtId;
      String transcationId = const Uuid().v4();

      // -------------------- 3️ CREATE TRANSACTION --------------------
      final transaction = TransactionModel(
        id: transcationId,
        type: state.transactionType,
        items: [
          TransactionItem(
            category: state.category.key,
            amount: amount,
            note: state.note,
          ),
        ],
        totalAmount: amount,
        paymentMethod: state.paymentMethod,
        date: state.selectedDateTime,
        isDebt: state.isDebt,
        debtId: null,
        attachmentPath: state.selectedImage?.path,
        budgetId: null,
        userId: AppPrefs.instance.userId,
      );

      final transactionResult = await saveNormalTranscationUsecase(
        transaction: transaction,
      );

      if (!transactionResult.success) {
        await _emitError(emit, 'Transaction failed');
        return;
      }

      // -------------------- 4️ SUCCESS --------------------
      emit(state.copyWith(transactionStatus: TransactionStatus.success));
    } catch (e) {
      await _emitError(emit, e.toString());
    }
  }

  Future<void> _onSaveDebtTransaction(
    SaveDebtTransaction event,
    Emitter<CategoryBottomSheetState> emit,
  ) async {
    try {
      // -------------------- 1️ VALIDATION --------------------
      final amount = double.tryParse(state.display) ?? 0;

      if (amount <= 0) {
        await _emitError(emit, 'Amount cannot be zero');
        return;
      }

      if (state.personName == null || state.personName!.isEmpty) {
        await _emitError(emit, 'Please add person name');
        return;
      }
      if (state.expectedReturnDate == null) {
        await _emitError(emit, 'Please add expected return date');
        return;
      }

      // -------------------- 2️ CREATE DEBT (ONLY IF NEEDED) --------------------
      String? debtId = const Uuid().v4();
      String transcationId = const Uuid().v4();

      final debtModel = DebtModel(
        id: debtId,
        transactionId: transcationId, // will link via transaction later
        personName: state.personName!,
        totalAmount: amount,
        debtType: state.debtType!,
        expectedReturnDate: state.expectedReturnDate!,
      );

      final debtResult = await addDebtUsecase(debt: debtModel);

      if (!debtResult.success) {
        await _emitError(emit, 'Failed to create debt');
        return; //  STOP – no transaction
      }

      // -------------------- 3️ CREATE TRANSACTION --------------------
      final transaction = TransactionModel(
        id: transcationId,
        type: state.transactionType,
        items: [
          TransactionItem(
            category: state.category.key,
            amount: amount,
            note: state.note,
          ),
        ],
        totalAmount: amount,
        paymentMethod: state.paymentMethod,
        date: state.selectedDateTime,
        isDebt: state.isDebt,
        debtId: debtId,
        attachmentPath: state.selectedImage?.path,
        budgetId: null,
        userId: AppPrefs.instance.userId,
      );

      final transactionResult = await saveDebtTranscationUsecase(
        transaction: transaction,
      );

      if (!transactionResult.success) {
        await _emitError(emit, 'Transaction failed');
        return;
      }

      // -------------------- 4️ SUCCESS --------------------
      emit(state.copyWith(transactionStatus: TransactionStatus.success));
    } catch (e) {
      await _emitError(emit, e.toString());
    }
  }

  Future<void> _onSaveDebtPayment(
    SaveDebtPayment event,
    Emitter<CategoryBottomSheetState> emit,
  ) async {
    try {
      String? debtpaymentId = const Uuid().v4();

      DebtPaymentModel debtPaymentModel = DebtPaymentModel(
        id: debtpaymentId,
        debtId: event.debtModel.id,
        amount: double.parse(state.display),
        paymentDate: state.selectedDateTime,
        paymentMethod: state.paymentMethod,
      );

      final result = await addDebtPaymentUseCase(
        paymentmodel: debtPaymentModel,
        debtModel: event.debtModel,
      );

      if (!result.success) {
        await _emitError(emit, 'Debt Payment  failed');
        return;
      } else {
        emit(state.copyWith(transactionStatus: TransactionStatus.success));
      }

      // -------------------- 4️ SUCCESS --------------------
      emit(state.copyWith(transactionStatus: TransactionStatus.success));
    } catch (e) {
      await _emitError(emit, e.toString());
    }
  }
}
