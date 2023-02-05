import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_crowd_sensing/services/notification_channels.dart';
import 'package:mobile_crowd_sensing/services/services_controller.dart';
import 'package:web3dart/web3dart.dart';
import '../models/db_capaign_model.dart';
import 'dart:async';
import 'dart:ui';


import 'package:geofence_flutter/geofence_flutter.dart';

class Services {
  @pragma('vm:entry-point')
  static void checkCloseCampaign(Map<dynamic, dynamic> args) async {
    DartPluginRegistrant.ensureInitialized();
    DbCampaignModel db = DbCampaignModel();
    List<Campaign> res = [];
    String accountAddress = args['accountAddress'];

    final FlutterLocalNotificationsPlugin notification =
        FlutterLocalNotificationsPlugin();

    await notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannel.importantChannel);

    Timer.periodic(const Duration(seconds: 60), (timer) async {
      ServicesController.statusCloseCampaignService = true;
      res = await db.campaigns();
      if (res.isNotEmpty) {
        for (Campaign c in res) {
          String address = c.address;
          String title = c.title;

          SmartContractModelBs smartContract = SmartContractModelBs(
              contractAddress: address,
              abiName: 'Campaign',
              abiFileRoot: 'assets/abi_campaign.json',
              accountAddress: accountAddress);

          List<dynamic>? isClosedRaw =
              await smartContract.queryCall('isClosed', []);

          if (isClosedRaw != null) {
            String answer = isClosedRaw[0].toString();

            if (answer == "true") {
              // the campaign result closed
              if (kDebugMode) {
                print('\x1B[31mThe campaign was closed\x1B[0m');
              }

              notification.show(
                888,
                'Campaign Closed',
                'The campaign [$title] \nat address $address \n was closed by crowdsourcer',
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'important_channel',
                    'MY FOREGROUND SERVICE',
                    icon: 'ic_bg_service_small',
                    ongoing: false,
                  ),
                ),
              );

              await db.deleteCampaign(address);
            } else {
              if (kDebugMode) {
                print('\x1B[31m [CLOSED CAMPAIGN SERVICE] The campaign still open: nothing to notify. \x1B[0m');
              }
            }
          } else {
            if (kDebugMode) {
              print(
                '\x1B[31m [CLOSED CAMPAIGN SERVICE]an error occurred. \x1B[0m');
            }
          }
        }
      } else {
        ServicesController.statusCloseCampaignService = false;
        timer.cancel();
        if (kDebugMode) {
          print(
            '\x1B[31m [CLOSED CAMPAIGN SERVICE] No campaigns to follow. stop the service.\x1B[0m');
        }
      }
    });
  }

  @pragma('vm:entry-point')
  static void checkGeofence(Map<String, String> args) async {
    DartPluginRegistrant.ensureInitialized();
    String debugString = "[GEOFENCE ${args["title"]!}";

    final FlutterLocalNotificationsPlugin notification =
        FlutterLocalNotificationsPlugin();

    await notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannel.importantChannel);

    if (kDebugMode) {
      print('\x1B[31m [GEOFENCE SERVICE] geofence open for:'
        '\n ${args['title']!}'
        '\n ${args['address']!}'
        '\n ${args['lat']!} '
        '\n ${args['lng']!} \x1B[0m');
    }

    await Geofence.startGeofenceService(
        pointedLatitude: args['lat']!,
        pointedLongitude: args['lng']!,
        radiusMeter: args['radius']!,
        eventPeriodInSeconds: 10
    );

    GeofenceEvent? previous;

    Geofence.getGeofenceStream()?.listen(
            (GeofenceEvent event) {
          if (kDebugMode) {
            print(event.toString());
          }

          if(previous == null || previous == GeofenceEvent.init) {
            switch (event) {
              case GeofenceEvent.enter:
                previous = event;
                break;
              case GeofenceEvent.exit:
                previous = event;
                break;
                default:
                  previous = event;
                  break;
            }
          }

          switch (event) {
            case GeofenceEvent.init:
              if (kDebugMode) {
                print('\x1B[31m $debugString status: Init\x1B[0m');
              }
              previous = event;
              break;
            case GeofenceEvent.enter:
              if (kDebugMode) {
                print('\x1B[31m $debugString status: Enter\x1B[0m');
              }
              (previous != event)?
                notification.show(
                  888,
                  'Entered in Campaign Area',
                  '[${args['title']!}] \nat address: ${args['address']!}',
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'important_channel',
                      'MY FOREGROUND SERVICE',
                      icon: 'ic_bg_service_small',
                      ongoing: true,
                    ),
                  ),
                )
              : print('\x1B[31m $debugString status not changed \x1B[0m');
              previous = event;
              break;
            case GeofenceEvent.exit:
              if (kDebugMode) {
                print('\x1B[31m $debugString status: Exit\x1B[0m');
              }
              (previous != event)?
                notification.show(
                    888,
                    'Exit from Campaign Area',
                    '[${args['title']!}] \nat address: ${args['address']!}',
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        'important_channel',
                        'MY FOREGROUND SERVICE',
                        icon: 'ic_bg_service_small',
                        ongoing: true,
                      ),
                    ))
              : print('\x1B[31m $debugString status not changed \x1B[0m');
              previous = event;

              break;
          }
        });
  }
}

class SmartContractModelBs {
  SmartContractModelBs(
      {required this.accountAddress,
      required this.contractAddress,
      required this.abiName,
      required this.abiFileRoot});

  final String accountAddress;
  final String contractAddress;
  final String abiName;
  final String abiFileRoot;
  late http.Client httpClient;
  late Web3Client ethClient;

  Future<DeployedContract> loadContract(String contractAddress) async {
    String abi = await rootBundle.loadString(abiFileRoot);
    final contract = DeployedContract(ContractAbi.fromJson(abi, abiName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>?> queryCall(
      String functionName, List<dynamic> args) async {
    try {
      httpClient = http.Client();
      ethClient = Web3Client(
          "https://goerli.infura.io/v3/5074605772bb4bc4b6970d2ce999efca",
          httpClient);

      final contract = await loadContract(contractAddress);
      final ethFunction = contract.function(functionName);
      final result = await ethClient.call(
          sender: EthereumAddress.fromHex(accountAddress),
          contract: contract,
          function: ethFunction,
          params: args);
      List<dynamic> res = result;
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31m$e\x1B[0m');
      }
      return null;
    }
  }
}


