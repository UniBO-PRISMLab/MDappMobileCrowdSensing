import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/notification_api.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'package:workmanager/workmanager.dart';

import 'db_capaign_model.dart';

const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        print("Inizio il task periodico");
        SessionModel sessionData = SessionModel();
        SmartContractModel smartContract = SmartContractModel(
            contractAddress: inputData!['address'],
            abiName: 'Campaign',
            abiFileRoot: 'assets/abi_campaign.json',
            provider: sessionData.getProvider());
        List<dynamic>? isClosedRaw = await smartContract.queryCall('isClosed', []);
        if (isClosedRaw != null) {
          String answer = isClosedRaw[0].toString();
          if (answer == "true") {
            NotificationApi.showNotification(
                title: "Campaign Closed by corowdsourcer",
                body: "this campaign is now colsed:\n ${inputData['title']}",
                payload: "Boh");
          } else if (answer == "false") { // to delete
            NotificationApi.showNotification(
                title: "Campaign still open",
                body: "this campaign is:\n ${inputData['title']}",
                payload: "Boh");
          }
        } else {
         return Future.error(StackTrace);
        }
        break;
    }
    return Future.value(true);
  });
}

Future<void> initializePeriodicTasks() async {
  DbCampaignModel db = DbCampaignModel();
  List<Campaign> res = await db.campaigns();

  if (res.isNotEmpty) {
    int counter = 0;
    for (Campaign c in res) {
      await Workmanager().registerPeriodicTask(
        "isOpen.${c.address}",
        fetchBackground,
        //frequency: const Duration(minutes: 15),
        initialDelay: const Duration(seconds: 3),
        constraints: Constraints(networkType: NetworkType.connected,),
        inputData: <String,String> {
          'address':c.address,
          'title': (c.title != null)? c.title as String : 'NaN',
        }
      ).then((value) => counter++);
    }

    print("sono stati registrati : $counter Tesk periodici");
  }
}

