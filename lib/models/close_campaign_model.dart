import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/controllers/close_campaign_controller.dart';
import 'smart_contract_model.dart';
import 'session_model.dart';
import '../views/dialog_view.dart';

class CloseCampaignModel {
  static Future<String> closeMyCampaign(
      BuildContext context) async {
    SessionModel sessionData = SessionModel();
    SmartContractModel smartContractViewModel = SmartContractModel(
        contractAddress: FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),
        abiName: 'MCSfactory',
        abiFileRoot: 'assets/abi.json',
        provider: sessionData.getProvider());
    dynamic res = await smartContractViewModel.queryTransaction(
        'closeCampaign', [], null);

    if (res.toString() != "null" &&
        res.toString() != "0x0000000000000000000000000000000000000000" &&
        !res.startsWith('JSON-RPC error')) {
      return 'Campaign Closed';
    }else if (res.startsWith('JSON-RPC error -32000:')){
      return res.split('JSON-RPC error -32000:').last.toString();
    }
    else {
      return 'An error Occurred.';
    }
  }
}
