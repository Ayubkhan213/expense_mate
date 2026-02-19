import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationSettings extends NotificationEvent {}

class UpdateTitle extends NotificationEvent {
  final String title;

  const UpdateTitle(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateBody extends NotificationEvent {
  final String body;

  const UpdateBody(this.body);

  @override
  List<Object?> get props => [body];
}

class UpdateTime extends NotificationEvent {
  final int hour;
  final int minute;

  const UpdateTime(this.hour, this.minute);

  @override
  List<Object?> get props => [hour, minute];
}

class UpdateImage extends NotificationEvent {
  final String? imagePath;

  const UpdateImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ScheduleNotification extends NotificationEvent {}

class CancelNotification extends NotificationEvent {}

class SendTestNotification extends NotificationEvent {}

class AddScheduleToList extends NotificationEvent {
  const AddScheduleToList();
}

class RemoveScheduleFromList extends NotificationEvent {
  final int id;

  const RemoveScheduleFromList(this.id);

  @override
  List<Object?> get props => [id];
}

class SaveAllSchedules extends NotificationEvent {
  const SaveAllSchedules();
}

class LoadAllSchedules extends NotificationEvent {
  const LoadAllSchedules();
}
