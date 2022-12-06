import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/providers/smart_contract_provider.dart';
import 'package:web3dart/credentials.dart';
import '../views/dialog_view.dart';
import '../views/sourcer_campaign_view.dart';

class CloseCampaignProvider extends StatefulWidget {
  const CloseCampaignProvider({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CloseCampaignProviderState createState() => _CloseCampaignProviderState();
}

class _CloseCampaignProviderState extends State<CloseCampaignProvider> {

  SessionViewModel sessionData = SessionViewModel();
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
    closeMyCampaign(sessionData.getAccountAddress());
  }

  @override
  Widget build(BuildContext context) {
    sessionData = SessionViewModel();
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.purple,
              size: 50.0,
            )));
  }

  Future<void> closeMyCampaign(String sourcerAddress) async {
    try {
      SmartContractProvider smartContractViewModel = SmartContractProvider(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json', provider: sessionData.getProvider());
      String address = jsonParameters['address'];
      List? result = await smartContractViewModel.queryCall(context, 'closeCampaign',[address],null,null);
      // ignore: unnecessary_non_null_assertion
      Navigator.pushReplacement(context!,MaterialPageRoute(builder: (context) => SourcerCampaignView(contractAddress: result!,)));
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














