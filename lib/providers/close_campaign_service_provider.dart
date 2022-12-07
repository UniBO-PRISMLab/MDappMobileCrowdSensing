import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/providers/smart_contract_provider.dart';
import '../views/dialog_view.dart';

class CloseCampaignServiceProvider extends StatefulWidget {
  const CloseCampaignServiceProvider({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CloseCampaignServiceProviderState createState() => _CloseCampaignServiceProviderState();
}

class _CloseCampaignServiceProviderState extends State<CloseCampaignServiceProvider> {

  SessionViewModel sessionData = SessionViewModel();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    closeMyCampaign();

    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.purple,
              size: 50.0,
            )));
  }

  Future<void> closeMyCampaign() async {
    try {

      SmartContractProvider smartContractViewModel = SmartContractProvider(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json', provider: sessionData.getProvider());

      List? result = await smartContractViewModel.queryTransaction('closeCampaign',[],null);

      if (result != null) {
          Navigator.pushReplacementNamed(context, '/sourcer');
      } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DialogView(message: "An error occurred.", goTo: 'home',)));
      }
    } catch (error) {
      if (kDebugMode) {
        print('\x1B[31m$error\x1B[0m');
      }
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    DialogView(message: error.toString())));
      });

    }
  }
}














