import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_crowd_sensing/services/servicesV2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/db_capaign_model.dart';
import 'notification_channels.dart';

class ServicesControllerV2 {
  static bool statusCloseCampaignService = false;
  static bool statusGeofencingService = false;

  static void initializeCloseCampaignService() async {
    FlutterBackgroundService s = FlutterBackgroundService();

    final FlutterLocalNotificationsPlugin notification =
    FlutterLocalNotificationsPlugin();
    await notification
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannel.backgroundServiceChannel);

    s.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: ServicesV2.onStart,
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: NotificationChannel.backgroundServiceChannel.id,
        initialNotificationTitle: NotificationChannel.backgroundServiceChannel.name,
        initialNotificationContent: 'service initialized',
        foregroundServiceNotificationId: 999,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: ServicesV2.onStart,
        onBackground: ServicesV2.onIosBackground,
      ),
    );
    s.startService();
    statusCloseCampaignService = true;
  }

  static void resetServicies() async {
    statusCloseCampaignService = true;
    initializeCloseCampaignService();
  }
}
