import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications + timezone
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    // 🔔 REQUIRED notification channel
    const channel = AndroidNotificationChannel(
      'alarm_channel',
      'Alarm Notifications',
      description: 'Exact alarm alerts',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('alarm_clock_1'),
      playSound: true,
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(channel);
  }

  /// Android 12+ requires user approval for exact alarms
  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return false;

    final canSchedule = await androidPlugin.canScheduleExactNotifications();

    if (canSchedule == true) return true;

    // Opens system permission screen
    await androidPlugin.requestExactAlarmsPermission();
    return false;
  }

  /// Schedule exact alarm (works when app is closed)
  static Future<void> scheduleAlarm({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          channelDescription: 'Exact alarm alerts',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm_clock_1'),
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      
    );
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
