import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/models/search_places_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'package:web3dart/credentials.dart';
import 'session_model.dart';

class MyCampaignModel {

  static Future<List?> getMyCampaign() async {
    try {
      SessionModel sessionData = SessionModel();
      String sourcerAddress = sessionData.getAccountAddress();
      SmartContractModel smartContractViewModel = SmartContractModel(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json', provider: sessionData.getProvider());
      EthereumAddress address = EthereumAddress.fromHex(sourcerAddress);
      return await smartContractViewModel.queryCall('activeCampaigns',[address],null);
    } catch (error) {
      if (kDebugMode) {
        print('\x1B[31m$error\x1B[0m');
      }
      return null;
    }
  }

  static Future<List?> getCampaignData(String contractAddress) async {
    SessionModel sessionData = SessionModel();
    SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();
    List? resInfo = [];
    SmartContractModel smartContractViewModel = SmartContractModel(
        contractAddress,
        'Campaign',
        'assets/abi_campaign.json',
        provider: sessionData.getProvider()
    );
    resInfo = await smartContractViewModel.queryCall('getInfo', [], null);
    resInfo?.add(
          (await searchPlacesViewModel.getReadebleLocationFromLatLng(
              (double.parse(resInfo[1].toString())) / 10000000,
              (double.parse(resInfo[2].toString())) / 10000000))
              .toString()
              .replaceAll(RegExp(r'[^\w\s]+'), ''));
    return (resInfo == null)? null : resInfo;
  }
}