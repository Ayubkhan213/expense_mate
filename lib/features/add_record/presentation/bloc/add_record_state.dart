import 'package:expense_mate/core/data/models/category_hive_model.dart';

enum AddRecordStatus { initial, loading, success, error }

class AddRecordState {
  bool isMultipleMode;
  List<CategoryHiveModel>? incomCategies;
  List<CategoryHiveModel>? expanceCategies;
  List<CategoryHiveModel>? selectedCategies;
  final AddRecordStatus status;
  final String? errorMessage;
  AddRecordState({
    this.isMultipleMode = false,
    this.expanceCategies,
    this.incomCategies,
    this.selectedCategies,
    this.status = AddRecordStatus.initial,
    this.errorMessage,
  });
  AddRecordState copyWith({
    bool? isMultipleMode,
    List<CategoryHiveModel>? incomCategies,
    List<CategoryHiveModel>? expanceCategies,
    List<CategoryHiveModel>? selectedCategies,
    AddRecordStatus? status,
    String? errorMessage,
  }) {
    return AddRecordState(
      isMultipleMode: isMultipleMode ?? this.isMultipleMode,
      incomCategies: incomCategies ?? this.incomCategies,
      expanceCategies: expanceCategies ?? this.expanceCategies,
      selectedCategies: selectedCategies ?? this.selectedCategies,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
