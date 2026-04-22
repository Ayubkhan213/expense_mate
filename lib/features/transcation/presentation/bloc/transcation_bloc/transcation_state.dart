import 'package:spendio/core/data/models/category_model.dart';

enum TranscationStatus { initial, loading, success, error }

class TranscationState {
  bool isMultipleMode;
  List<CategoryModel>? incomCategies;
  List<CategoryModel>? expanceCategies;
  List<CategoryModel>? selectedCategies;
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
    List<CategoryModel>? incomCategies,
    List<CategoryModel>? expanceCategies,
    List<CategoryModel>? selectedCategies,
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
