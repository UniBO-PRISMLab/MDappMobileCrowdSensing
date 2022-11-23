import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/providers/smart_contract_provider.dart';
import '../views/dialog_view.dart';
import '../views/worker_campaign_view.dart';

class AllCampaignProvider extends StatefulWidget {
  const AllCampaignProvider({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AllCampaignProviderState createState() => _AllCampaignProviderState();
}

class _AllCampaignProviderState extends State<AllCampaignProvider> {

  SessionViewModel sessionData = SessionViewModel();
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
    getAllCampaign(sessionData.getAccountAddress());
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

  Future<void> getAllCampaign(String sourcerAddress) async {
    try {
      SmartContractProvider smartContractViewModel = SmartContractProvider(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json');

      List? result = await smartContractViewModel.queryCall(context, 'getAllCampaigns',[],null,null);
      // ignore: unnecessary_non_null_assertion
      Navigator.pushReplacement(context!,MaterialPageRoute(builder: (context) => WorkerCampaignView(contractAddress: result![0],)));
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














