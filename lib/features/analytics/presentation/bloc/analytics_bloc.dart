import 'package:expense_mate/features/analytics/domain/repository/analytics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository repository;

  AnalyticsBloc({required this.repository}) : super(const AnalyticsInitial()) {
    on<LoadAnalyticsData>(_onLoadAnalyticsData);
    on<RefreshAnalytics>(_onRefreshAnalytics);
    on<FilterAnalyticsByPeriod>(_onFilterByPeriod);
    on<FilterAnalyticsByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadAnalyticsData(
    LoadAnalyticsData event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    try {
      final data = await repository.getAnalyticsData(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(
        AnalyticsLoaded(
          data: data,
          currentPeriod: AnalyticsPeriod.month,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    } catch (e) {
      emit(AnalyticsError('Failed to load analytics: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    if (state is AnalyticsLoaded) {
      final currentState = state as AnalyticsLoaded;

      try {
        final data = await repository.getAnalyticsData(
          startDate: currentState.startDate,
          endDate: currentState.endDate,
          categoryFilter: currentState.selectedCategory,
        );

        emit(currentState.copyWith(data: data));
      } catch (e) {
        emit(AnalyticsError('Failed to refresh analytics: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterByPeriod(
    FilterAnalyticsByPeriod event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    try {
      final dateRange = _getDateRangeForPeriod(event.period);
      final data = await repository.getAnalyticsData(
        startDate: dateRange.start,
        endDate: dateRange.end,
      );

      emit(
        AnalyticsLoaded(
          data: data,
          currentPeriod: event.period,
          startDate: dateRange.start,
          endDate: dateRange.end,
        ),
      );
    } catch (e) {
      emit(AnalyticsError('Failed to filter analytics: ${e.toString()}'));
    }
  }

  Future<void> _onFilterByCategory(
    FilterAnalyticsByCategory event,
    Emitter<AnalyticsState> emit,
  ) async {
    if (state is AnalyticsLoaded) {
      final currentState = state as AnalyticsLoaded;
      emit(const AnalyticsLoading());

      try {
        final data = await repository.getAnalyticsData(
          startDate: currentState.startDate,
          endDate: currentState.endDate,
          categoryFilter: event.categoryKey,
        );

        emit(
          currentState.copyWith(
            data: data,
            selectedCategory: event.categoryKey,
          ),
        );
      } catch (e) {
        emit(AnalyticsError('Failed to filter by category: ${e.toString()}'));
      }
    }
  }

  DateRange _getDateRangeForPeriod(AnalyticsPeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case AnalyticsPeriod.week:
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        return DateRange(start: startOfWeek, end: today);

      case AnalyticsPeriod.month:
        final startOfMonth = DateTime(now.year, now.month, 1);
        return DateRange(start: startOfMonth, end: today);

      case AnalyticsPeriod.threeMonths:
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return DateRange(start: threeMonthsAgo, end: today);

      case AnalyticsPeriod.sixMonths:
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        return DateRange(start: sixMonthsAgo, end: today);

      case AnalyticsPeriod.year:
        final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        return DateRange(start: oneYearAgo, end: today);

      case AnalyticsPeriod.all:
        // Get first transaction date or use 5 years ago as fallback
        final fiveYearsAgo = DateTime(now.year - 5, now.month, now.day);
        return DateRange(start: fiveYearsAgo, end: today);
    }
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});
}
