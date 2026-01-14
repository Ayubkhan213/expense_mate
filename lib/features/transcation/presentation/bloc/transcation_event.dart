import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/features/transcation/presentation/components/category_section/components/category_grid/components/category_bottom_sheet/bloc/category_bottom_sheet_state.dart';

abstract class TransactionEvent {}

class ToggleSelectionTabs extends TransactionEvent {
  final bool isMultipleSelection;
  ToggleSelectionTabs({required this.isMultipleSelection});
}

class FetchAllExpancesEvent extends TransactionEvent {}

class FetchAllIncomEvent extends TransactionEvent {}

class ToggleCategorySelection extends TransactionEvent {
  final CategoryHiveModel selectedCategory;

  ToggleCategorySelection({required this.selectedCategory});
}

class ClearSelectionEvent extends TransactionEvent {}

class AddingTransactionEvent extends TransactionEvent {
  final CategoryBottomSheetState sheetState;
  final String? userId;

  AddingTransactionEvent({required this.sheetState, this.userId});
}
