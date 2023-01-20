import 'package:mobile_crowd_sensing/models/notification_api.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'db_capaign_model.dart';

import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    DbCampaignModel db = DbCampaignModel();
    List<Campaign> res = await db.campaigns();
    SessionModel session = SessionModel();

    print("\n DEBUG1_______________________________________\n ${res.toString()}\n");
    print("\n DEBUG2_______________________________________\n ${session.connector.session.toString()}\n");

    if (res.isNotEmpty) {
      int counter = 0;
      for (Campaign c in res) {
        // bring to foreground
        Timer.periodic(const Duration(seconds: 10), (timer) async {
          if (service is AndroidServiceInstance) {
            if (await service.isForegroundService()) {
              //await _process(c.address, c.title!);
            }
          }
        });
        counter++;
      }
      print("\nsono stati registrati : $counter Tasks periodici\n");
    } else {
      print("\nNessun Task da registrare\n");
    }

      print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'my_foreground', // id
    'info', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      // notificationChannelId: 'my_foreground',
      // initialNotificationTitle: 'AWESOME SERVICE',
      // initialNotificationContent: 'Initializing',
      // foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}


// Future<void> _process(String address, String title) async {
//   SmartContractModel smartContract = SmartContractModel(
//       contractAddress: address,
//       abiName: 'Campaign',
//       abiFileRoot: 'assets/abi_campaign.json',
//       provider: );
//
//   List<dynamic>? isClosedRaw = await smartContract.queryCall('isClosed', []);
//   if (isClosedRaw != null) {
//     String answer = isClosedRaw[0].toString();
//     if (answer == "true") {
//       NotificationApi.showNotification(
//           title: "Campaign Closed by corowdsourcer",
//           body: "this campaign is now colsed:\n $title}",
//           payload: "Boh");
//     } else if (answer == "false") {
//       // to delete
//       NotificationApi.showNotification(
//           title: "Campaign still open",
//           body: "this campaign is:\n $title",
//           payload: "Boh");
//     }
//   } else {
//     return Future.error(StackTrace);
//   }
// }