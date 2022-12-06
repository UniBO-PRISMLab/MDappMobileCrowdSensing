import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/providers/smart_contract_provider.dart';
import 'package:web3dart/credentials.dart';
import '../views/dialog_view.dart';
import '../views/sourcer_campaign_view.dart';

class MyCampaignProvider extends StatefulWidget {
  const MyCampaignProvider({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyCampaignProviderState createState() => _MyCampaignProviderState();
}

class _MyCampaignProviderState extends State<MyCampaignProvider> {
  final createCampaignProvider = GlobalKey<ScaffoldState>();

  SessionViewModel sessionData = SessionViewModel();
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
    getMyCampaign(sessionData.getAccountAddress());
  }

  @override
  Widget build(BuildContext context) {
    sessionData = SessionViewModel();

    return Scaffold(
        key: createCampaignProvider,
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.purple,
              size: 50.0,
            )));
  }

  Future<void> getMyCampaign(String sourcerAddress) async {
    try {
      SmartContractProvider smartContractViewModel = SmartContractProvider(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json', provider: sessionData.getProvider());
      EthereumAddress address = EthereumAddress.fromHex(sourcerAddress);
      List? result = await smartContractViewModel.queryCall(context, 'activeCampaigns',[address],null,null);
      if (result != null) {
        setState(() {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SourcerCampaignView(contractAddress: result,)));
        });
      } else {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const DialogView(goTo: "sourcer", message: 'No Campaign Aviable')));
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














