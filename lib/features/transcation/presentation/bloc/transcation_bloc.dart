// ignore_for_file: avoid_print

import 'package:expense_mate/core/data/models/category_hive_model.dart';

import 'package:expense_mate/core/domain/repository/category_repository.dart';
// import 'package:expense_mate/features/transcation/domain/use_cases/create_budget_transcation.dart';
import 'package:expense_mate/features/transcation/domain/use_cases/create_debt_transcation.dart';
import 'package:expense_mate/features/transcation/domain/use_cases/create_normal_transcation.dart';
import 'package:expense_mate/features/transcation/domain/use_cases/create_recurring_transcation.dart';
import 'package:expense_mate/features/transcation/presentation/bloc/transcation_event.dart';
import 'package:expense_mate/features/transcation/presentation/bloc/transcation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TranscationBloc extends Bloc<TransactionEvent, TranscationState> {
  CategoryRepository categoryRepository;
  // CreateBudgetTransaction createBudgetTransaction;
  // CreateDebtTransaction createDebtTransaction;
  // CreateNormalTransaction createNormalTransaction;
  // ProcessDueRecurring processDueRecurring;

  TranscationBloc({
    required this.categoryRepository,
    // required this.createBudgetTransaction,
    // required this.createDebtTransaction,
    // required this.createNormalTransaction,
    // required this.processDueRecurring,
  }) : super(TranscationState()) {
    on<ToggleSelectionTabs>((event, emit) {
      emit(
        state.copyWith(
          isMultipleMode: event.isMultipleSelection,
          selectedCategies: [],
        ),
      );
    });
    on<FetchAllExpancesEvent>(_fetcAllhExpanceCategory);
    on<FetchAllIncomEvent>(_fetchAllIncomCategory);
    on<ToggleCategorySelection>(_toggleCategorySelection);
    on<ClearSelectionEvent>(_clearSelection);
    // on<TransactionEvent>((event, emit) async {
    //   try {
    //     emit(state.copyWith(status: TranscationStatus.loading));

    //     final s = event.sheetState;

    //     // 1️ TransactionItem
    //     final item = TransactionItem(
    //       category: s.category.key,
    //       amount: double.parse(s.display),
    //       note: s.note,
    //     );

    //     // 2️ TransactionModel
    //     final transactionId = const Uuid().v4();

    //     final transaction = TransactionModel(
    //       id: transactionId,
    //       userId: event.userId, // null = guest
    //       type: s.transactionType,
    //       items: [item],
    //       totalAmount: item.amount,
    //       paymentMethod: s.paymentMethod,
    //       date: s.selectedDateTime,
    //       isDebt: s.isDebt,
    //       isRecurring: s.isRecurring ?? false,
    //       attachmentPath: s.selectedImage?.path,
    //     );

    //     await transactionBox.put(transactionId, transaction);

    //     // 3️ Debt (ONLY if selected)
    //     if (s.isDebt && s.debtType != null) {
    //       final debt = DebtModel(
    //         id: const Uuid().v4(),
    //         transactionId: transactionId,
    //         personName: s.personName ?? '',
    //         totalAmount: item.amount,
    //         debtType: s.debtType!,
    //         expectedReturnDate: s.expectedReturnDate!,
    //       );

    //       await debtBox.put(debt.id, debt);

    //       // update transaction with debtId
    //       await transaction.save();
    //     }

    //     // 4️ Recurring (OPTIONAL – future)
    //     if (s.isRecurring == true) {
    //       // Save recurring rule here later
    //     }

    //     emit(state.copyWith(status: TranscationStatus.success));
    //   } catch (e) {
    //     emit(
    //       state.copyWith(
    //         status: TranscationStatus.failure,
    //         error: e.toString(),
    //       ),
    //     );
    //   }
    // });
  }

  _fetcAllhExpanceCategory(
    FetchAllExpancesEvent event,
    Emitter<TranscationState> emit,
  ) {
    emit(state.copyWith(status: TranscationStatus.loading));
    try {
      List<CategoryHiveModel> expanceList = categoryRepository.getExpense();
      emit(
        state.copyWith(
          status: TranscationStatus.success,
          expanceCategies: expanceList,
        ),
      );
    } catch (e, stack) {
      print('--------- Expance Category Fetching Bloc ----------');
      print(stack);
      emit(
        state.copyWith(
          status: TranscationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  _fetchAllIncomCategory(
    FetchAllIncomEvent event,
    Emitter<TranscationState> emit,
  ) {
    try {
      emit(state.copyWith(status: TranscationStatus.loading));
      List<CategoryHiveModel> incomeList = categoryRepository.getIncome();
      emit(
        state.copyWith(
          status: TranscationStatus.success,
          incomCategies: incomeList,
        ),
      );
    } catch (e, stack) {
      print('---------- Income Category Fetching Bloc ----------');
      print(stack);
      emit(
        state.copyWith(
          status: TranscationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  _toggleCategorySelection(
    ToggleCategorySelection event,
    Emitter<TranscationState> emit,
  ) {
    final currentSelected = List<CategoryHiveModel>.from(
      state.selectedCategies ?? [],
    );
    final index = currentSelected.indexWhere(
      (e) => e.key == event.selectedCategory.key,
    );

    //Multiple Selection Mood
    if (state.isMultipleMode) {
      //Multiple Selection mode
      if (index != -1) {
        //Tab again -> deselect
        currentSelected.removeAt(index);
      } else {
        //select new
        currentSelected.add(event.selectedCategory);
      }
    } else {
      if (index != -1) {
        //tab again -> deselect
        currentSelected.clear();
      } else {
        //replace old with new
        currentSelected
          ..clear()
          ..add(event.selectedCategory);
      }
    }
    emit(state.copyWith(selectedCategies: currentSelected));
  }

  _clearSelection(ClearSelectionEvent event, Emitter<TranscationState> emit) {
    emit(state.copyWith(selectedCategies: []));
  }
}
