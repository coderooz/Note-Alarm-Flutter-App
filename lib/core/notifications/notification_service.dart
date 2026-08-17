import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications + timezone
  static Future<void> init() async {
    tz.initializeTimeZones();
    await _setLocalTimeZone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings);

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

  /// Configure the timezone database so alarms fire at the correct local time.
  static Future<void> _setLocalTimeZone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } catch (e) {
      // Fall back to UTC; scheduling still works, times may be offset.
      debugPrint('Failed to resolve local timezone: $e');
    }
  }

  /// Android 13+ requires runtime approval to post notifications.
  static Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return false;

    final granted = await androidPlugin.requestNotificationsPermission();
    return granted ?? false;
  }

  /// Android 12+ requires user approval for exact alarms.
  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return false;

    final canSchedule = await androidPlugin.canScheduleExactNotifications();
    if (canSchedule == true) return true;

    final granted = await androidPlugin.requestExactAlarmsPermission();
    return granted ?? false;
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
