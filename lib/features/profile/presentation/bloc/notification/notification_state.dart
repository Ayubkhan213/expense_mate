import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/data/models/notification_secdular.dart';

enum NotificationStatus { initial, loading, loaded, success, error }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final String title;
  final String body;
  final int hour;
  final int minute;
  final String? imagePath;
  final bool isEnabled;
  final String? errorMessage;
  final String? successMessage;
  final List<NotificationSchedule> schedules;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.title = 'Daily Reminder',
    this.body = 'Don\'t forget to track your expenses!',
    this.hour = 9,
    this.minute = 0,
    this.imagePath,
    this.isEnabled = false,
    this.schedules = const [],
    this.errorMessage,
    this.successMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    String? title,
    String? body,
    int? hour,
    int? minute,
    String? imagePath,
    List<NotificationSchedule>? schedules,
    bool? isEnabled,
    String? errorMessage,
    String? successMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      title: title ?? this.title,
      body: body ?? this.body,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      imagePath: imagePath ?? this.imagePath,
      isEnabled: isEnabled ?? this.isEnabled,
      schedules: schedules ?? this.schedules,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    title,
    body,
    hour,
    minute,
    imagePath,
    isEnabled,
    schedules,
    errorMessage,
    successMessage,
  ];
}
