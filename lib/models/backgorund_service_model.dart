import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mobile_crowd_sensing/models/notification_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'db_capaign_model.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DbCampaignModel db = DbCampaignModel();
  List<Campaign> res = await db.campaigns();
  SharedPreferences shared = await SharedPreferences.getInstance();
  String? accountAddress = shared.getString('address');
  if(accountAddress == null) {
    throw NullThrownError();
  }
  if (res.isNotEmpty) {
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

      int counter = 0;
      for (Campaign c in res) {
        Timer.periodic(const Duration(minutes: 30), (timer) async {
          if (service is AndroidServiceInstance) {
            if (await service.isForegroundService()) {
              print('\x1B[31mEseguo _process per la $counter volta.\x1B[0m');
              await _process(accountAddress,c.address, c.title!);
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

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}


Future<void> _process(String accountAdress, String address, String title) async {
  SmartContractModel_Bs smartContract = SmartContractModel_Bs(
      contractAddress:address,
      abiName: 'Campaign',
      abiFileRoot: 'assets/abi_campaign.json',
      accountAddress: accountAdress);

  List<dynamic>? isClosedRaw = await smartContract.queryCall('isClosed', []);
  if (isClosedRaw != null) {
    String answer = isClosedRaw[0].toString();

    if (answer == "true") {
      NotificationApi.showNotification(
          title: "Campaign Closed by corowdsourcer",
          body: "this campaign is now colsed:\n $title}",
          payload: "Boh");
      // rimuovi la campagna dal db
    } else if (answer == "false") {
      print('\x1B[31mThe campaign still open: nothing to notify\x1B[0m');
    }
  } else {
    return Future.error(StackTrace);
  }
}

class SmartContractModel_Bs {
  SmartContractModel_Bs({required this.accountAddress,required this.contractAddress, required this.abiName, required this.abiFileRoot});
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

  Future<List<dynamic>?> queryCall(String functionName, List<dynamic> args) async {
    try {

      httpClient = http.Client();
      ethClient = Web3Client("https://goerli.infura.io/v3/5074605772bb4bc4b6970d2ce999efca", httpClient);


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
