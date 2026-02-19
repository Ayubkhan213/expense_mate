import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/data/models/analytics_data_models.dart';

import 'analytics_event.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData data;
  final AnalyticsPeriod currentPeriod;
  final String? selectedCategory;
  final DateTime startDate;
  final DateTime endDate;

  const AnalyticsLoaded({
    required this.data,
    required this.currentPeriod,
    this.selectedCategory,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
    data,
    currentPeriod,
    selectedCategory,
    startDate,
    endDate,
  ];

  AnalyticsLoaded copyWith({
    AnalyticsData? data,
    AnalyticsPeriod? currentPeriod,
    String? selectedCategory,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AnalyticsLoaded(
      data: data ?? this.data,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
