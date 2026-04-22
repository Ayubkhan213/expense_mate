import 'daily_notification_service.dart';
import 'package:spendio/core/data/models/notification_secdular.dart';

class AutoNotificationScheduler {
  static final List<NotificationSchedule> _defaultSchedules = [
    // NotificationSchedule(
    //   id: 1,
    //   title: '🧪 Test Notification',
    //   body: 'This is a test — app was closed!',
    //   hour: 13, // ← your current hour
    //   minute: 45, // ← current minute + 2
    // ),
    NotificationSchedule(
      id: 1,
      title: '☀️ Good Morning!',
      body:
          'Set a spending intention for today. Small steps lead to big savings.',
      hour: 8,
      minute: 0,
    ),
    NotificationSchedule(
      id: 2,
      title: '📊 Midday Check-in',
      body:
          'Any morning expenses to log? Staying on top keeps your budget accurate.',
      hour: 13,
      minute: 00,
    ),
    NotificationSchedule(
      id: 3,
      title: '🌙 Daily Wrap-up',
      body:
          'Take 2 minutes to review today\'s spending. Your future self will thank you.',
      hour: 00,
      minute: 0,
    ),
  ];

  /// Runs on every app open — always reschedules to keep notifications alive
  static Future<void> scheduleIfNeeded() async {
    final service = DailyNotificationService();
    await service.initialize();
    await service.saveAllSchedules(_defaultSchedules);
  }
}
