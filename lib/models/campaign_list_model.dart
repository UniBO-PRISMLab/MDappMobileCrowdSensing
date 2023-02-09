import 'package:flutter_config/flutter_config.dart';

import 'db_capaign_model.dart';
import 'smart_contract_model.dart';
import 'search_places_model.dart';
import 'session_model.dart';

class CampaignListModel {
  static Future<List<dynamic>> getData(List<dynamic>? contractAddress) async {
    SessionModel sessionData = SessionModel();
    SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();

    List<dynamic>? dataComposition = [];
    List<dynamic> out = [];

    DbCampaignModel db = DbCampaignModel();
    List<Campaign> res = await db.campaigns();

    if (contractAddress != null) {
      SmartContractModel smartContractViewModel;
      SmartContractModel factoryContract = SmartContractModel(
          contractAddress: FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),
          abiName: 'MCSfactory',
          abiFileRoot: 'assets/abi.json',
          provider: sessionData.getProvider()
      );

      for (int i = 0; i < contractAddress.length; i++) {
        smartContractViewModel = SmartContractModel(
            contractAddress: contractAddress[i].toString(),
            abiName: 'Campaign',
            abiFileRoot: 'assets/abi_campaign.json',
            provider: sessionData.getProvider());
        dataComposition = await smartContractViewModel.queryCall('getInfo', []);
        dataComposition?.add(contractAddress[i].toString());
        dataComposition?.add(
            (await searchPlacesViewModel.getReadebleLocationFromLatLng(
                    (double.parse(dataComposition[1].toString())) / 10000000,
                    (double.parse(dataComposition[2].toString())) / 10000000))
                .toString()
                .replaceAll(RegExp(r'[^\w\s]+'), ''));
        dataComposition?.add((await _checkIfIsInCampaignsDb(res,dataComposition[7].toString())).toString());
        dataComposition?.add((await factoryContract.queryCall('balanceOf', [contractAddress[i]]))![0]);
        out.add(dataComposition);
      }
    }
    return out;
  }

  static Future<bool> _checkIfIsInCampaignsDb(List<Campaign> storedCampaigns,String campaignAddress) async {
    Campaign result = storedCampaigns.singleWhere((element) => element.address == campaignAddress,
        orElse: () => const Campaign(title: 'fake', lat: '', lng: '', radius: '', address: ''));
    if (result.title != "fake") {
      return true;
    } else {
      return false;
    }
  }
}
