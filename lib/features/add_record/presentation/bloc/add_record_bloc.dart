// ignore_for_file: avoid_print

import 'package:expense_mate/core/app_export.dart';

import 'package:expense_mate/core/domain/repository/category_repository.dart';

class AddRecordBloc extends Bloc<AddRecordEvent, AddRecordState> {
  CategoryRepository categoryRepository;

  AddRecordBloc({required this.categoryRepository}) : super(AddRecordState()) {
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
  }

  _fetcAllhExpanceCategory(
    FetchAllExpancesEvent event,
    Emitter<AddRecordState> emit,
  ) {
    emit(state.copyWith(status: AddRecordStatus.loading));
    try {
      List<CategoryHiveModel> expanceList = categoryRepository.getExpense();
      emit(
        state.copyWith(
          status: AddRecordStatus.success,
          expanceCategies: expanceList,
        ),
      );
    } catch (e, stack) {
      print('--------- Expance Category Fetching Bloc ----------');
      print(stack);
      emit(
        state.copyWith(
          status: AddRecordStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  _fetchAllIncomCategory(
    FetchAllIncomEvent event,
    Emitter<AddRecordState> emit,
  ) {
    try {
      emit(state.copyWith(status: AddRecordStatus.loading));
      List<CategoryHiveModel> incomeList = categoryRepository.getIncome();
      emit(
        state.copyWith(
          status: AddRecordStatus.success,
          incomCategies: incomeList,
        ),
      );
    } catch (e, stack) {
      print('---------- Income Category Fetching Bloc ----------');
      print(stack);
      emit(
        state.copyWith(
          status: AddRecordStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  _toggleCategorySelection(
    ToggleCategorySelection event,
    Emitter<AddRecordState> emit,
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

  _clearSelection(ClearSelectionEvent event, Emitter<AddRecordState> emit) {
    emit(state.copyWith(selectedCategies: []));
  }
}
