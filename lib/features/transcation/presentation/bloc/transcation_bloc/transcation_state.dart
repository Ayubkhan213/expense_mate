import 'package:expense_mate/core/data/models/category_hive_model.dart';

enum TranscationStatus { initial, loading, success, error }

class TranscationState {
  bool isMultipleMode;
  List<CategoryHiveModel>? incomCategies;
  List<CategoryHiveModel>? expanceCategies;
  List<CategoryHiveModel>? selectedCategies;
  final TranscationStatus status;
  final String? errorMessage;
  TranscationState({
    this.isMultipleMode = false,
    this.expanceCategies,
    this.incomCategies,
    this.selectedCategies,
    this.status = TranscationStatus.initial,
    this.errorMessage,
  });
  TranscationState copyWith({
    bool? isMultipleMode,
    List<CategoryHiveModel>? incomCategies,
    List<CategoryHiveModel>? expanceCategies,
    List<CategoryHiveModel>? selectedCategies,
    TranscationStatus? status,
    String? errorMessage,
  }) {
    return TranscationState(
      isMultipleMode: isMultipleMode ?? this.isMultipleMode,
      incomCategies: incomCategies ?? this.incomCategies,
      expanceCategies: expanceCategies ?? this.expanceCategies,
      selectedCategies: selectedCategies ?? this.selectedCategies,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
