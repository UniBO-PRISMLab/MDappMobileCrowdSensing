import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_crowd_sensing/services/services.dart';
import 'notification_channels.dart';

class ServicesController {
  static bool statusBackgroundService = false;

  static void initializeBackgroundService() async {
    FlutterBackgroundService s = FlutterBackgroundService();

    final FlutterLocalNotificationsPlugin notification =
    FlutterLocalNotificationsPlugin();
    await notification
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannel.backgroundServiceChannel);

    s.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: Services.onStart,
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: NotificationChannel.backgroundServiceChannel.id,
        initialNotificationTitle: NotificationChannel.backgroundServiceChannel.name,
        initialNotificationContent: 'service initialized',
        foregroundServiceNotificationId: 999,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: Services.onStart,
      ),
    );
    s.startService();
    statusBackgroundService = true;
  }

  static void resetService() async {
    statusBackgroundService = true;
    initializeBackgroundService();
  }
}
