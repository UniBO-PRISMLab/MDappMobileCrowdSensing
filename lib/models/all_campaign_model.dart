import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import '../controllers/all_campaign_controller.dart';
import 'smart_contract_model.dart';
import '../views/dialog_view.dart';

class AllCampaignModelCampaignModel {

  static Future<void> getAllCampaign(BuildContext context,String cameFrom) async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json', provider: sessionData.getProvider());
      await smartContractViewModel.queryCall('getAllCampaigns',[],null).then((value) => {
        AllCampaignController.routingTo(context,value,cameFrom)
      });

    } catch (error) {
      if (kDebugMode) {
        print('\x1B[31m$error\x1B[0m');
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DialogView(message: error.toString())));
    }

  }
}