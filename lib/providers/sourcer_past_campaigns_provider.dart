import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/providers/smart_contract_provider.dart';
import 'package:web3dart/credentials.dart';
import '../views/dialog_view.dart';
import '../views/sourcer_closed_campaign_view.dart';

class ClosedCampaignProvider extends StatefulWidget {

  const ClosedCampaignProvider({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ClosedCampaignProviderState createState() => _ClosedCampaignProviderState();
}

class _ClosedCampaignProviderState extends State<ClosedCampaignProvider> {
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
    getMyClosedCampaign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.purple,
              size: 50.0,
            )));
  }

  Future<void> getMyClosedCampaign() async {
    try {
      SessionViewModel sessionData = SessionViewModel();
      SmartContractProvider smartContractViewModel = SmartContractProvider(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json', provider: sessionData.getProvider());
      EthereumAddress address = EthereumAddress.fromHex(sessionData.getAccountAddress());
      List<String>? result = [];
      int index = 0;
      List<dynamic>? query = [];

      do {
        query = await smartContractViewModel.queryCall('closedCampaigns', [address, BigInt.from(index)], null);

         if (query.toString() != "null") {
           print("ADDED: ${query![0].toString()}");
           result.add(query[0].toString());
         }
        index++;
      } while (query.toString() != "null");

      if (result.isNotEmpty) {
        setState(() {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SourcerClosedCampaignView(contractAddress: result,)));
        });
      } else {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const DialogView(goTo: "sourcer", message: 'No Campaigns Aviable')));
        });
      }
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
  }

}














