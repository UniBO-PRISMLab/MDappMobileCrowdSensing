import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'smart_contract_model.dart';
import 'session_model.dart';

class CreateCampaignModel {

  static Future<String> createCampaign(BuildContext context,String name, BigInt lat, BigInt lng, BigInt range,String type, BigInt value) async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(contractAddress:FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),abiName: 'MCSfactory',abiFileRoot: 'assets/abi.json', provider: sessionData.getProvider());
      List args = [name, lat, lng, range,type];
      dynamic res = await smartContractViewModel.queryTransaction('createCampaign', args,value);
      if (res.toString() != "null" &&
          res.toString() != "0x0000000000000000000000000000000000000000" &&
          !res.startsWith('JSON-RPC error')) {
        return 'Campaign Created';
      }else if (res.startsWith('JSON-RPC error -32000:')){
        return res.split('JSON-RPC error -32000:').last.toString();
      }
      else {
        return 'An error Occurred.';
      }
    } catch (error) {
      return 'Unknown error.';
    }
  }

}