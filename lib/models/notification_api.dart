import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          "channelId",
          "channelName",
          channelDescription: "channelDescription",
          importance: Importance.max,
          priority: Priority.max,
          ticker: 'ticker',
          icon: 'ic_bg_service_small',
      ),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title, body, payload,
  }) async => _notifications.show(
    id,
    title,
    body,
    await _notificationDetails(),
    payload: payload
  );

  static void showScheduledNotification({
    int id = 0,
    String? title, body, payload,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          await _notificationDetails(),
          payload: payload,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
      );
}