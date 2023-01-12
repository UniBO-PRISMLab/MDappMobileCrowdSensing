import 'smart_contract_model.dart';
import 'search_places_model.dart';
import 'session_model.dart';

class VerifierCampaignModel {
  static Future<dynamic>? getData(List<dynamic>? contractAddress) async {
    SessionModel sessionData = SessionModel();
    SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();

    List? resInfo = [];
    List? dataFirstPart = [];
    if (contractAddress != null) {
      SmartContractModel smartContractViewModel;
      for (int i = 0; i < contractAddress.length; i++) {
        smartContractViewModel = SmartContractModel(
            contractAddress: contractAddress[i].toString(),
            abiName: 'Campaign',
            abiFileRoot: 'assets/abi_campaign.json',
            provider: sessionData.getProvider());
        dataFirstPart = await smartContractViewModel.queryCall('getInfo', []);
        dataFirstPart?.add(contractAddress[i].toString());
        dataFirstPart?.add(
            (await searchPlacesViewModel.getReadebleLocationFromLatLng(
                    (double.parse(dataFirstPart[1].toString())) / 10000000,
                    (double.parse(dataFirstPart[2].toString())) / 10000000))
                .toString()
                .replaceAll(RegExp(r'[^\w\s]+'), ''));
        resInfo.add(dataFirstPart);
      }
    }
    return resInfo;
  }
}
