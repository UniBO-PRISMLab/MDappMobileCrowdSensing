import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';

import 'ipfs_client_model.dart';

class CampaignDataLightModel {

  static Future<List<LightData>> preparePage(String campaignAddress) async {
    List<LightData> contents = [];
    late SmartContractModel smartContract = SmartContractModel(
        contractAddress: campaignAddress,
        abiName: 'Campaign',
        abiFileRoot: 'assets/abi_campaign.json',
        provider:  SessionModel().getProvider());

    List<dynamic>? allfilesPathRes =
    await smartContract.queryCall('getValidFiles', []);
    if (allfilesPathRes != null) {
      for (dynamic element in allfilesPathRes[0]) {
        String? res = await IpfsClientModel.downloadItemIPFS(element, 'lights');
        if (res != null) {
          List<String> value = res.split('/');
          contents.add(LightData(
              DateTime.fromMillisecondsSinceEpoch(int.parse(value[0])),
              double.parse(value[1])));
        }
      }
    }

    return contents;
  }

}

class LightData {
  LightData(this.timeStamp, this.value);
  final DateTime timeStamp;
  final double value;
}