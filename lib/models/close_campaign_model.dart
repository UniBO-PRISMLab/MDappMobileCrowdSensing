import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/controllers/close_campaign_controller.dart';
import 'smart_contract_model.dart';
import 'session_model.dart';
import '../views/dialog_view.dart';

class CloseCampaignModel {

  static Future<void> closeMyCampaign(BuildContext context,String address) async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(address,'Campaing','assets/abi_campaign.json', provider: sessionData.getProvider());
      await smartContractViewModel.queryTransaction('closeCampaign',[],null).then((value) => {
          CloseCampaignController.routing(context,value)
      });
    } catch (error) {
      if (kDebugMode) {
        print('\x1B[31m$error\x1B[0m');
      }
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    DialogView(message: error.toString())));
      });
    }
  }
}