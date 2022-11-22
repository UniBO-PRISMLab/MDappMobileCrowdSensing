import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/view_models/smart_contract_view_model.dart';

import '../views/dialog_view.dart';

class CampaignCreator extends StatefulWidget {
  const CampaignCreator({super.key});
  @override
  _CampaignCreatorState createState() => _CampaignCreatorState();
}

class _CampaignCreatorState extends State<CampaignCreator> {
  final createCampaignProvider = GlobalKey<ScaffoldState>();

  late SessionViewModel sessionData;
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sessionData = SessionViewModel();
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    createCampaign(
        jsonParameters['title'],
        BigInt.from(jsonParameters['lat']),
        BigInt.from(jsonParameters['lng']),
        BigInt.from(jsonParameters['range']),
        BigInt.from(jsonParameters['payment']),
    );
    return Scaffold(
        key: createCampaignProvider,
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.green,
              size: 50.0,
            )));
  }

  Future<void> createCampaign(String name, BigInt lat, BigInt lng, BigInt range, BigInt value) async {
    try {

      SmartContractViewModel smartContractViewModel = SmartContractViewModel(
          FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'), 'MCSfactory',
          'assets/abi.json');
      List args = [name, lat, lng, range];
      List<dynamic> result = await smartContractViewModel.queryTransaction(
          context, 'createCampaign', args, value, 'sourcer');

    } catch(error){
      print('\x1B[31m$error\x1B[0m');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DialogView(message: error.toString())));
    }
  }
}
