import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:web3dart/credentials.dart';
import 'smart_contract_model.dart';
import 'session_model.dart';
import '../views/dialog_view.dart';

class SourcerPastCampaignsModel {
  static Future<List?> getMyClosedCampaign(BuildContext context) async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(
          contractAddress: FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),
          abiName: 'MCSfactory',
          abiFileRoot: 'assets/abi.json',
          provider: sessionData.getProvider());
      List<dynamic>? query =
          await smartContractViewModel.queryCall('getClosedCampaigns', []);
      if (query.toString() != "null") {
        return query![0];
      }
      return null;
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
    return null;
  }
}
