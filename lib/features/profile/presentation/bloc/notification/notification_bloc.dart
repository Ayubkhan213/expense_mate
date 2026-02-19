import 'package:expense_mate/core/data/models/notification_secdular.dart';
import 'package:expense_mate/core/services/daily_notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final DailyNotificationService _service;

  NotificationBloc({DailyNotificationService? service})
    : _service = service ?? DailyNotificationService(),
      super(const NotificationState()) {
    on<LoadNotificationSettings>(_onLoadSettings);
    on<UpdateTitle>(_onUpdateTitle);
    on<UpdateBody>(_onUpdateBody);
    on<UpdateTime>(_onUpdateTime);
    on<UpdateImage>(_onUpdateImage);
    on<ScheduleNotification>(_onScheduleNotification);
    on<CancelNotification>(_onCancelNotification);
    on<SendTestNotification>(_onSendTestNotification);
    on<AddScheduleToList>(_onAddScheduleToList);
    on<RemoveScheduleFromList>(_onRemoveScheduleFromList);
    on<SaveAllSchedules>(_onSaveAllSchedules);
    on<LoadAllSchedules>(_onLoadAllSchedules);
  }
  void _onAddScheduleToList(
    AddScheduleToList event,
    Emitter<NotificationState> emit,
  ) {
    if (state.title.isEmpty || state.body.isEmpty) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Please enter title and message',
        ),
      );
      return;
    }

    final newSchedule = NotificationSchedule(
      id: state.schedules.length,
      title: state.title,
      body: state.body,
      hour: state.hour,
      minute: state.minute,
      imagePath: state.imagePath,
    );

    final updatedSchedules = [...state.schedules, newSchedule];

    emit(
      state.copyWith(
        schedules: updatedSchedules,
        status: NotificationStatus.success,
        successMessage: 'Schedule added! Tap "Save All" to activate.',
      ),
    );
  }

  void _onRemoveScheduleFromList(
    RemoveScheduleFromList event,
    Emitter<NotificationState> emit,
  ) {
    final updatedSchedules = state.schedules
        .where((s) => s.id != event.id)
        .toList();

    emit(state.copyWith(schedules: updatedSchedules));
  }

  Future<void> _onSaveAllSchedules(
    SaveAllSchedules event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.schedules.isEmpty) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'No schedules to save',
        ),
      );
      return;
    }

    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      await _service.saveAllSchedules(state.schedules);

      emit(
        state.copyWith(
          status: NotificationStatus.success,
          isEnabled: true,
          successMessage: 'All notifications scheduled successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Error saving schedules: $e',
        ),
      );
    }
  }

  Future<void> _onLoadAllSchedules(
    LoadAllSchedules event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      final schedules = await _service.getAllSchedules();

      emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          schedules: schedules,
          isEnabled: schedules.isNotEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Failed to load schedules: $e',
        ),
      );
    }
  }

  Future<void> _onLoadSettings(
    LoadNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      final settings = await _service.getNotificationSettings();

      if (settings != null) {
        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            title: settings['title'],
            body: settings['body'],
            hour: settings['hour'],
            minute: settings['minute'],
            imagePath: settings['imagePath'],
            isEnabled: true,
          ),
        );
      } else {
        emit(state.copyWith(status: NotificationStatus.loaded));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Failed to load settings: $e',
        ),
      );
    }
  }

  void _onUpdateTitle(UpdateTitle event, Emitter<NotificationState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onUpdateBody(UpdateBody event, Emitter<NotificationState> emit) {
    emit(state.copyWith(body: event.body));
  }

  void _onUpdateTime(UpdateTime event, Emitter<NotificationState> emit) {
    emit(state.copyWith(hour: event.hour, minute: event.minute));
  }

  void _onUpdateImage(UpdateImage event, Emitter<NotificationState> emit) {
    emit(state.copyWith(imagePath: event.imagePath));
  }

  Future<void> _onScheduleNotification(
    ScheduleNotification event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.title.isEmpty || state.body.isEmpty) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Please enter title and message',
        ),
      );
      return;
    }

    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      await _service.scheduleSingleNotification(
        title: state.title,
        body: state.body,
        hour: state.hour,
        minute: state.minute,
        imagePath: state.imagePath,
      );

      emit(
        state.copyWith(
          status: NotificationStatus.success,
          isEnabled: true,
          successMessage: 'Daily notification scheduled successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Error scheduling notification: $e',
        ),
      );
    }
  }

  Future<void> _onCancelNotification(
    CancelNotification event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      await _service.cancelDailyNotification();

      emit(
        state.copyWith(
          status: NotificationStatus.success,
          isEnabled: false,
          successMessage: 'Daily notification cancelled',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Error cancelling notification: $e',
        ),
      );
    }
  }

  Future<void> _onSendTestNotification(
    SendTestNotification event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.title.isEmpty || state.body.isEmpty) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Please enter title and message',
        ),
      );
      return;
    }

    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      await _service.showTestNotification(
        state.title,
        state.body,
        state.imagePath,
      );

      emit(
        state.copyWith(
          status: NotificationStatus.success,
          successMessage: 'Test notification sent!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: 'Error sending test notification: $e',
        ),
      );
    }
  }
}
