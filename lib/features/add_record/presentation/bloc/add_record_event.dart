import 'package:expense_mate/core/app_export.dart';

class AddRecordEvent {}

class ToggleSelectionTabs extends AddRecordEvent {
  final bool isMultipleSelection;
  ToggleSelectionTabs({required this.isMultipleSelection});
}

class FetchAllExpancesEvent extends AddRecordEvent {}

class FetchAllIncomEvent extends AddRecordEvent {}

class ToggleCategorySelection extends AddRecordEvent {
  final CategoryHiveModel selectedCategory;

  ToggleCategorySelection({required this.selectedCategory});
}

class ClearSelectionEvent extends AddRecordEvent {}
