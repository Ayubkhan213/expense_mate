import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsData extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadAnalyticsData({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class RefreshAnalytics extends AnalyticsEvent {
  const RefreshAnalytics();
}

class FilterAnalyticsByPeriod extends AnalyticsEvent {
  final AnalyticsPeriod period;

  const FilterAnalyticsByPeriod(this.period);

  @override
  List<Object?> get props => [period];
}

class FilterAnalyticsByCategory extends AnalyticsEvent {
  final String? categoryKey;

  const FilterAnalyticsByCategory(this.categoryKey);

  @override
  List<Object?> get props => [categoryKey];
}

enum AnalyticsPeriod { week, month, threeMonths, sixMonths, year, all }
