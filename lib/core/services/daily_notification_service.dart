import 'dart:convert';
import 'dart:io';
import 'package:expense_mate/core/data/models/notification_secdular.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class DailyNotificationService {
  static final DailyNotificationService _instance =
      DailyNotificationService._internal();
  factory DailyNotificationService() => _instance;
  DailyNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _notificationChannelId = 'daily_reminders';
  static const String _notificationChannelName = 'Daily Reminders';

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      onDidReceiveNotificationResponse: _onNotificationTapped,
      settings: initSettings,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      await android.requestNotificationsPermission();
    }

    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      await ios.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? imagePath,
  }) async {
    final androidDetails = await _createAndroidDetails(imagePath);
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      scheduledDate: tzScheduledDate,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> saveAllSchedules(List<NotificationSchedule> schedules) async {
    final prefs = await SharedPreferences.getInstance();

    await _notifications.cancelAll();

    final jsonList = schedules.map((s) => s.toJson()).toList();
    await prefs.setString('notification_schedules', jsonEncode(jsonList));

    for (final schedule in schedules) {
      await scheduleDailyNotification(
        id: schedule.id,
        title: schedule.title,
        body: schedule.body,
        hour: schedule.hour,
        minute: schedule.minute,
        imagePath: schedule.imagePath,
      );
    }
  }

  Future<List<NotificationSchedule>> getAllSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('notification_schedules');

    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => NotificationSchedule.fromJson(json)).toList();
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notification_schedules');
  }

  /// Backward compatibility - schedule single notification with ID 0
  Future<void> scheduleSingleNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? imagePath,
  }) async {
    await _saveNotificationSettings(title, body, hour, minute, imagePath);
    await scheduleDailyNotification(
      id: 0,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
      imagePath: imagePath,
    );
  }

  Future<AndroidNotificationDetails> _createAndroidDetails(
    String? imagePath,
  ) async {
    StyleInformation? styleInformation;

    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          final bigPictureStyle = BigPictureStyleInformation(
            FilePathAndroidBitmap(imagePath),
            largeIcon: FilePathAndroidBitmap(imagePath),
            contentTitle: null,
            summaryText: null,
            hideExpandedLargeIcon: false,
          );
          styleInformation = bigPictureStyle;
        }
      } catch (e) {
        print('Error loading image: $e');
      }
    }

    return AndroidNotificationDetails(
      _notificationChannelId,
      _notificationChannelName,
      channelDescription: 'Daily reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: styleInformation,
      largeIcon: imagePath != null && imagePath.isNotEmpty
          ? FilePathAndroidBitmap(imagePath)
          : null,
    );
  }

  Future<void> cancelDailyNotification() async {
    await _notifications.cancel(id: 0);
    await _clearNotificationSettings();
  }

  Future<bool> isNotificationScheduled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('notification_enabled');
  }

  Future<Map<String, dynamic>?> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('notification_enabled')) return null;

    return {
      'title': prefs.getString('notification_title') ?? '',
      'body': prefs.getString('notification_body') ?? '',
      'hour': prefs.getInt('notification_hour') ?? 9,
      'minute': prefs.getInt('notification_minute') ?? 0,
      'imagePath': prefs.getString('notification_image'),
    };
  }

  Future<void> _saveNotificationSettings(
    String title,
    String body,
    int hour,
    int minute,
    String? imagePath,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', true);
    await prefs.setString('notification_title', title);
    await prefs.setString('notification_body', body);
    await prefs.setInt('notification_hour', hour);
    await prefs.setInt('notification_minute', minute);
    if (imagePath != null) {
      await prefs.setString('notification_image', imagePath);
    }
  }

  Future<void> _clearNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notification_enabled');
    await prefs.remove('notification_title');
    await prefs.remove('notification_body');
    await prefs.remove('notification_hour');
    await prefs.remove('notification_minute');
    await prefs.remove('notification_image');
  }

  Future<void> showTestNotification(
    String title,
    String body,
    String? imagePath,
  ) async {
    final androidDetails = await _createAndroidDetails(imagePath);
    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id: 999,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
