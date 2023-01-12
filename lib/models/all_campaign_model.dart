import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'smart_contract_model.dart';

class AllCampaignModelCampaignModel {

  static Future<List?> getAllCampaign() async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(contractAddress: FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),abiName: 'MCSfactory',abiFileRoot: 'assets/abi.json', provider: sessionData.getProvider());
      return await smartContractViewModel.queryCall('getAllCampaigns',[]);

    } catch (error) {
      if (kDebugMode) {
        print('\x1B[31m$error\x1B[0m');
      }
      return null;
    }
  }
}