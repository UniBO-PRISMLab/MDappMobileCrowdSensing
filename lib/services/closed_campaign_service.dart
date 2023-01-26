import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_crowd_sensing/services/geofencing.dart';
import 'package:mobile_crowd_sensing/services/notification_channels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../models/db_capaign_model.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class ClosedCampaignService {
  static final ClosedCampaignService _instance =
      ClosedCampaignService._internal();

  static late bool isInitialized;

  void setIsInizialized(bool status) {
    ClosedCampaignService.isInitialized = status;
  }

  bool checkIfInitialized() {
    return ClosedCampaignService.isInitialized;
  }

  factory ClosedCampaignService() {
    return _instance;
  }

  ClosedCampaignService._internal() {
    ClosedCampaignService.isInitialized = false;
  }

  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    DbCampaignModel db = DbCampaignModel();
    List<Campaign> res = [];

    SharedPreferences shared = await SharedPreferences.getInstance();
    String? accountAddress = shared.getString('address');

    //List<Geofencing> geofencingList = [];

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      res = await db.campaigns();
      //geofencingList.clear();

      SmartContractModelBs smartContract;
      if (kDebugMode) {
        print(
            '\x1B[31m[CLOSED CAMPAIGN SERVICE]check db. IS EMPTY? ${res.isEmpty} \x1B[0m');
      }
      if (res.isNotEmpty) {
        int counter = 0;
        for (Campaign c in res) {
          Geofencing g = Geofencing(
              id: c.address,
              pointedLatitude: c.lat,
              pointedLongitude: c.lng,
              radiusMeter: c.radius);

          switch (g.getStatus()) {
            case GeofenceStatus.init:
              print('\x1B[31m [GEOFENCE] status: Init\x1B[0m');
              break;
            case GeofenceStatus.enter:
              print('\x1B[31m [GEOFENCE] status: Enter\x1B[0m');
              flutterLocalNotificationsPlugin.show(
                888,
                'Entered in Campaign Area',
                '[${c.title}] \nat address: ${c.address}',
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
            case GeofenceStatus.exit:
              print('\x1B[31m [GEOFENCE] status: Exit\x1B[0m');
              flutterLocalNotificationsPlugin.show(
                  888,
                  'Exit from Campaign Area',
                  '[${c.title}] \nat address: ${c.address}',
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'important_channel',
                      'MY FOREGROUND SERVICE',
                      icon: 'ic_bg_service_small',
                      ongoing: true,
                    ),
                  ));
              break;
            default:
              print(
                  '\x1B[31m [GEOFENCE] status DEFAULT Exit: ${g.getStatus()}\x1B[0m');
              break;
          }

          g.stopGeofenceService();

          if (accountAddress == null) {
            throw NullThrownError();
          }
          String address = c.address;
          String title = c.title;

          smartContract = SmartContractModelBs(
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
              if (service is AndroidServiceInstance) {
                if (await service.isForegroundService()) {
                  flutterLocalNotificationsPlugin.show(
                    888,
                    'Campaign Closed',
                    'The campaign [$title] \nat address $address \n was closed by crowdsourcer',
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        'important_channel',
                        'MY FOREGROUND SERVICE',
                        icon: 'ic_bg_service_small',
                        ongoing: true,
                      ),
                    ),
                  );
                }
              }
              await db.deleteCampaign(address);
            } else {
              print(
                  '\x1B[31mThe campaign still open: nothing to notify\x1B[0m');
            }
          } else {
            return Future.error(StackTrace);
          }

          counter++;
        }
        if (kDebugMode) {
          print(
              "\n [CLOSED CAMPAIGN SERVICE]registered : $counter periodic Tasks\n");
        }
      } else {
        if (kDebugMode) {
          print(
              '\x1B[31m [CLOSED CAMPAIGN SERVICE] No campaigns to follow. stop the service.\x1B[0m');
        }
        ClosedCampaignService().setIsInizialized(false);
        print(
            '\x1B[31m[DEBUG CANCELLAZIONE SERVIZIO]${ClosedCampaignService().checkIfInitialized()}\x1B[0m');
        timer.cancel();
        service.stopSelf();
      }
    });

    print('\x1B[31m[GEOFENCE SERVICE] try to execute the service\x1B[0m');
  }

  Future<void> initializeClosedCampaignService() async {
    ClosedCampaignService().setIsInizialized(true);
    DbCampaignModel db = DbCampaignModel();
    List<Campaign> res = await db.campaigns();
    if (res.isNotEmpty) {
      print(
          '\x1B[31m [CLOSED CAMPAIGN SERVICE]Initialize service [CLOSED CAMPAIGN]\x1B[0m');

      final service = FlutterBackgroundService();

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(NotificationChannel.importantChannel);

      await service.configure(
        androidConfiguration: AndroidConfiguration(
// this will be executed when app is in foreground or background in separated isolate
          onStart: ClosedCampaignService.onStart,

// auto start service
          autoStart: true,
          isForegroundMode: true,

          notificationChannelId: 'important_channel',
          initialNotificationTitle: 'closing campaign service',
          initialNotificationContent:
              'this service notify eventually submitted campaign closed',
          foregroundServiceNotificationId: 888,
        ),
        iosConfiguration: IosConfiguration(),
      );

      service.startService();
    } else {
      if (kDebugMode) {
        print(
            '\x1B[31m [CLOSED CAMPAIGN SERVICE]The database is empty. no services to initialize\x1B[0m');
      }
    }
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
