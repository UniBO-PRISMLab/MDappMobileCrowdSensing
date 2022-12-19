import 'smart_contract_model.dart';
import 'search_places_model.dart';
import 'session_model.dart';

class VerifierCampaignDataModel {

  static Future<dynamic>? getData(String contractAddress) async {
    SessionModel sessionData = SessionModel();
    SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();
    late SmartContractModel smartContract;

    if (contractAddress != "0x0000000000000000000000000000000000000000") {
      smartContract = SmartContractModel(contractAddress, 'Campaign', 'assets/abi_campaign.json',
          provider: sessionData.getProvider());
      String? readebleLocationQuery;

      await smartContract
          .queryCall('getInfo', [], null)
          .then((value) async =>
      {
        if (value != null)
          {
            readebleLocationQuery = await searchPlacesViewModel
                .getReadebleLocationFromLatLng(
                (double.parse(value[1].toString())) / 10000000,
                (double.parse(value[2].toString())) / 10000000),
            // setState(() {
            //   name = value[0];
            //   latitude = value[1].toString();
            //   longitude = value[2].toString();
            //   range = value[3].toString();
            //   type = value[4];
            //   addressCrowdSourcer = value[5].toString();
            //   readebleLocation = readebleLocationQuery;
            // })
          }
      });
    }
    List<dynamic>? fileCountRaw =
    await smartContract.queryCall('fileCount', [], null);
    List<dynamic>? fileCheckedRaw =
    await smartContract.queryCall('checkedFiles', [], null);
    // if (mounted) {
    //   setState(() {
    //     if (fileCheckedRaw != null) {
    //       fileChecked = fileCheckedRaw[0].toString();
    //     }
    //     if (fileCountRaw != null) {
    //       fileCount = fileCountRaw[0].toString();
    //     }
    //
    //     //to implement in the contract
    //     workersCount = 'NaN';
    //   });
    // }
  }
}