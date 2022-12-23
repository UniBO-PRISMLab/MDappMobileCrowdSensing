import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'smart_contract_model.dart';
import 'session_model.dart';

class CreateCampaignModel {

  static Future<bool> createCampaign(BuildContext context,String name, BigInt lat, BigInt lng, BigInt range,String type, BigInt value) async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'), 'MCSfactory', 'assets/abi.json', provider: sessionData.getProvider());
      List args = [name, lat, lng, range,type];
      dynamic res = await smartContractViewModel.queryTransaction('createCampaign', args,value);
      if (res.toString() != "null" &&
          res.toString() != "0x0000000000000000000000000000000000000000") {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

}