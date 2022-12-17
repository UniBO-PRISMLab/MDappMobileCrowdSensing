import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/controller/create_campaign_controller.dart';
import 'smart_contract_model.dart';
import '../view_models/session_view_model.dart';
import '../views/dialog_view.dart';

class CreateCampaignModel {

  static Future<void> createCampaign(BuildContext context,String name, BigInt lat, BigInt lng, BigInt range,String type, BigInt value) async {
    try {
      SessionViewModel sessionData = SessionViewModel();
      SmartContractModel smartContractViewModel = SmartContractModel(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'), 'MCSfactory', 'assets/abi.json', provider: sessionData.getProvider());
      List args = [name, lat, lng, range,type];
      await smartContractViewModel.queryTransaction('createCampaign', args,value).then((value) async => {
        CreateCampaignController.routingTo(context, value)
      });
    } catch (error) {
      print('\x1B[31m$error\x1B[0m');
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DialogView(message: '[uploadLight]: $error')));
      });
    }
  }

}