import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_crowd_sensing/controllers/geofence_controller.dart';
import 'package:mobile_crowd_sensing/services/notification_channels.dart';
import '../models/db_capaign_model.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../models/geofence_model.dart';
import 'geofence_status.dart';

//@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DbCampaignModel db = DbCampaignModel();
  List<Campaign> res = await db.campaigns();
  if (res.isNotEmpty) {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    int i =0;
    for (GeofenceModel g in GeofenceController.geofenceList) {
      i++;
      print('\x1B[31m [GEOFENCE SERVICE] Read the stream for the : $i time\x1B[0m');
      g.getGeofenceStream()!.listen((event) {
        switch(event) {
          case GeofenceStatus.enter:
            if (kDebugMode) {
              print('\x1B[31m [GEOFENCE SERVICE] Enter Status \x1B[0m');
            }
            flutterLocalNotificationsPlugin.show(
              999,
              'Enter in a Campaign area',
              'you are inside a Campaign area',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'important_channel',
                  'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                ),
              ));
            break;
          case GeofenceStatus.exit:
            if (kDebugMode) {
              print('\x1B[31m [GEOFENCE SERVICE] Exit Status \x1B[0m');
            }
            flutterLocalNotificationsPlugin.show(
                999,
                'Exit from Campaign area',
                'you are out from the area',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'important_channel',
                  'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                ),
              ),
            );
            break;
          case GeofenceStatus.init:
            if (kDebugMode) {
              print('\x1B[31m [GEOFENCE SERVICE] init Status \x1B[0m');
            }
            break;
        }
      });
    }
  } else {
    if (kDebugMode) {
      print('\x1B[31m [GEOFENCE SERVICE] database empty: the service '
          'was closed after start\x1B[0m');
    }
    service.stopSelf();
  }
}

Future<void> initializeGeofencingService() async {
  DbCampaignModel db = DbCampaignModel();
  List<Campaign> res = await db.campaigns();
  if (res.isNotEmpty) {

    // check the permission for geolocation

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print('\x1B[31m [GEOFENCE SERVICE]Inizializzazione del servizio: [GEOFENCE]\x1B[0m');

    GeofenceController.geofenceInitByDb();

    FlutterBackgroundService service = FlutterBackgroundService();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannel.importantChannel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: 'important_channel',
        initialNotificationTitle: 'geofence service',
        initialNotificationContent:
            'this service notify eventually submitted campaign area entrance',
        foregroundServiceNotificationId: 999,
      ),
      iosConfiguration: IosConfiguration(),
    );

    service.startService();
  } else {
    print('\x1B[31m [GEOFENCE SERVICE]The database is empty. no services to initialize\x1B[0m');
  }
}
