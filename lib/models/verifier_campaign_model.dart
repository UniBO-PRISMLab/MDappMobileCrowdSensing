import 'smart_contract_model.dart';
import '../view_models/search_places_view_model.dart';
import '../view_models/session_view_model.dart';

class VerifierCampaignModel {

  static Future<dynamic>? getData(List<dynamic>? contractAddress) async {
    SessionViewModel sessionData = SessionViewModel();
    SearchPlacesViewModel searchPlacesViewModel = SearchPlacesViewModel();

    List? resInfo = [];
    List? dataFirstPart = [];
    if (contractAddress != null) {
      SmartContractModel smartContractViewModel;
      for (int i = 0; i < contractAddress.length; i++) {
        smartContractViewModel = SmartContractModel(
            contractAddress[i].toString(), 'Campaign',
            'assets/abi_campaign.json', provider: sessionData.getProvider());
        dataFirstPart =
        await smartContractViewModel.queryCall('getInfo', [], null);
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