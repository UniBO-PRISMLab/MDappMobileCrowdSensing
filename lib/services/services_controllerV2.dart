import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mobile_crowd_sensing/services/servicesV2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/db_capaign_model.dart';
import 'notification_channels.dart';

class ServicesControllerV2 {
  static bool statusCloseCampaignService = false;
  static bool statusGeofencingService = false;
  static List<FlutterBackgroundService> servicesList = [];
  static void initializeCloseCampaignService() async {
    FlutterBackgroundService s = FlutterBackgroundService();

    s.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: ServicesV2.checkCloseCampaign,
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: NotificationChannel.importantChannel_2.id,
        initialNotificationTitle: NotificationChannel.importantChannel_2.name,
        initialNotificationContent: 'closing campaign service',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: ServicesV2.checkCloseCampaign,
        onBackground: ServicesV2.onIosBackground,
      ),
    );
    servicesList.add(s);
    statusCloseCampaignService = true;
  }

  static Future initializeGeofencingService() async {
    DbCampaignModel db = DbCampaignModel();
    List<Campaign> res = await db.campaigns();
    if (res.isNotEmpty) {
      statusGeofencingService = true;
      for (Campaign c in res) {
        FlutterBackgroundService s = FlutterBackgroundService();
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('address',c.address);
        shared.setString('title', c.title);
        shared.setString('lat',c.lat);
        shared.setString('lng',c.lng);
        shared.setString('radius', c.radius);
        s.configure(
          androidConfiguration: AndroidConfiguration(
            onStart: ServicesV2.checkGeofence,
            autoStart: true,
            isForegroundMode: true,

            notificationChannelId: NotificationChannel.importantChannel.id,
            initialNotificationTitle: NotificationChannel.importantChannel.name,
            initialNotificationContent: 'geofence: ${c.title}',
            foregroundServiceNotificationId: 999,
          ),
          iosConfiguration: IosConfiguration(
            autoStart: true,
            onForeground: ServicesV2.checkGeofence,
            onBackground: ServicesV2.onIosBackground,
          ),
        );
        print('\x1B[31m sono iniziato almeno? ${await s.startService()}\x1B[0m');
        servicesList.add(s);
      }
    }
  }

  static void resetServicies() async {
    servicesList.forEach((element) {
      element.invoke('stopService');
    });
    statusCloseCampaignService = true;
    statusGeofencingService = true;
    initializeCloseCampaignService();
    initializeGeofencingService();
  }
}
