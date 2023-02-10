import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_crowd_sensing/models/db_session_model.dart';
import 'package:mobile_crowd_sensing/services/notification_channels.dart';
import 'package:mobile_crowd_sensing/services/services_controllerV2.dart';
import 'package:web3dart/web3dart.dart';
import '../models/db_capaign_model.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import '../models/geofence_model.dart';

class ServicesV2 {
  static void onStart(ServiceInstance service) async {
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
    DbSessionModel dbSession = DbSessionModel();
    List<Campaign> res = [];
    List<Session> sessionRes = [];
    List<Geofence> geoList = [];

    final FlutterLocalNotificationsPlugin notification =
        FlutterLocalNotificationsPlugin();

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      ServicesControllerV2.statusCloseCampaignService = true;
      sessionRes = await dbSession.sessions();
      String accountAddress = sessionRes[0].account;
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
                999,
                'Campaign Closed',
                'The campaign [$title] \nat address $address \n was closed by crowdsourcer',
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    NotificationChannel.backgroundServiceChannel.id,
                    NotificationChannel.backgroundServiceChannel.name,
                    icon: 'ic_bg_service_small',
                    styleInformation: BigTextStyleInformation(
                        "<p>The campaign \"$title\" \n campaign at address: \n$address \n was closed by the crowdsoucer</p>",
                        htmlFormatBigText: true,
                        contentTitle: "<h1>CLOSED \"$title\"</h1>",
                        htmlFormatContentTitle: true,
                        summaryText: "<p>this campaign is now closed</p>",
                        htmlFormatSummaryText: true,
                        htmlFormatContent: true,
                        htmlFormatTitle: true),
                    ongoing: true,
                  ),
                ),
              );

              await db.deleteCampaign(address);
            } else {
              if (kDebugMode) {
                print(
                    '\x1B[31m [CLOSED CAMPAIGN SERVICE] The campaign still open: nothing to notify. \x1B[0m');
              }
            }
          } else {
            if (kDebugMode) {
              print(
                  '\x1B[31m [CLOSED CAMPAIGN SERVICE]an error occurred. \x1B[0m');
            }
          }
        }

        //.....
        for (var element in geoList) {element.stopGeofenceService();}
        geoList.clear();
        for (Campaign c in res) {
          Geofence g = Geofence(c.title, c.address, c.lat, c.lng, c.radius);
            geoList.add(g);
            g.initialize();
        }
        if (kDebugMode) {
          print('\x1B[31m [GEOFENCE SERVICE] active geofences: ${geoList.length}. \x1B[0m');
        }
      } else {
        ServicesControllerV2.statusCloseCampaignService = false;
        timer.cancel();
        for (var element in geoList) {element.stopGeofenceService();}
        geoList.clear();
        service.stopSelf();
        if (kDebugMode) {
          print(
              '\x1B[31m [CLOSED CAMPAIGN SERVICE] No campaigns to follow. stop the service.\x1B[0m');
        }
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
