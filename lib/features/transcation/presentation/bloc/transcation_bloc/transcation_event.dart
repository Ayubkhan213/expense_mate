import 'package:spendio/core/data/models/category_model.dart';
import 'package:spendio/features/transcation/presentation/bloc/category_bottom_sheet_bloc/category_bottom_sheet_state.dart';

abstract class TransactionEvent {}

class ToggleSelectionTabs extends TransactionEvent {
  final bool isMultipleSelection;
  ToggleSelectionTabs({required this.isMultipleSelection});
}

class FetchAllExpancesEvent extends TransactionEvent {}

class FetchAllIncomEvent extends TransactionEvent {}

class ToggleCategorySelection extends TransactionEvent {
  final CategoryModel selectedCategory;

  ToggleCategorySelection({required this.selectedCategory});
}

class ClearSelectionEvent extends TransactionEvent {}

class AddingTransactionEvent extends TransactionEvent {
  final CategoryBottomSheetState sheetState;
  final String? userId;

  AddingTransactionEvent({required this.sheetState, this.userId});
}
