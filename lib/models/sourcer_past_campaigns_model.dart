import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:web3dart/credentials.dart';
import 'smart_contract_model.dart';
import 'session_model.dart';
import '../views/dialog_view.dart';

class SourcerPastCampaignsModel {

  static Future<List<String>?> getMyClosedCampaign(BuildContext context) async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(contractAddress:FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),abiName: 'MCSfactory',abiFileRoot: 'assets/abi.json', provider: sessionData.getProvider());
      EthereumAddress address = EthereumAddress.fromHex(sessionData.getAccountAddress());
      List<String>? result = [];
      int index = 0;
      List<dynamic>? query = [];

      do {
        query = await smartContractViewModel.queryCall('closedCampaigns', [address, BigInt.from(index)]);

        if (query.toString() != "null") {
          result.add(query![0].toString());
        }
        index++;
      } while (query.toString() != "null");

      return result;
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