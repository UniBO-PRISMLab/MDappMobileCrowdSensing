import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
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

//@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      print('\x1B[31mSet in foreground\x1B[0m');
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      print('\x1B[31mSet in background\x1B[0m');
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    print('\x1B[31m stop service\x1B[0m');
    service.stopSelf();
  });

  DbCampaignModel db = DbCampaignModel();
  List<Campaign> res = await db.campaigns();
  SmartContractModel_Bs smartContract;
  if (res.isNotEmpty) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    int counter = 0;
    for (Campaign c in res) {
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (kDebugMode) {
          print('\x1B[31mEseguo _process per la $counter volta.\x1B[0m');
        }

        SharedPreferences shared = await SharedPreferences.getInstance();
        String? accountAddress = shared.getString('address');
        if (accountAddress == null) {
          throw NullThrownError();
        }
        String address = c.address;
        String title = c.title!;

        smartContract = SmartContractModel_Bs(
            contractAddress: address,
            abiName: 'Campaign',
            abiFileRoot: 'assets/abi_campaign.json',
            accountAddress: accountAddress);

        List<dynamic>? isClosedRaw =
            await smartContract.queryCall('isClosed', []);
        if (isClosedRaw != null) {
          String answer = isClosedRaw[0].toString();

          if (answer == "true") {
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
          } else if (answer == "false") {
            print('\x1B[31mThe campaign still open: nothing to notify\x1B[0m');
          }
        } else {
          return Future.error(StackTrace);
        }
      });
      counter++;
    }
    if (kDebugMode) {
      print("\nsono stati registrati : $counter Tasks periodici\n");
    }
  } else {
    if (kDebugMode) {
      print('\x1B[31mNessuna camapagna da seguire\x1B[0m');
    }
    service.invoke("stopService");
  }
}

Future<void> initializeClosedCampaignService() async {
  DbCampaignModel db = DbCampaignModel();
  List<Campaign> res = await db.campaigns();
  if (res.isNotEmpty) {
    print(
        '\x1B[31mInizializzazione del servizio [CLOSED CAMPAIGN]\x1B[0m');

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
        onStart: onStart,

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
    print('\x1B[31mThe database is empty. no services to initialize\x1B[0m');
  }
}

class SmartContractModel_Bs {
  SmartContractModel_Bs(
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
