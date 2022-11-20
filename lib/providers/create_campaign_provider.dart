import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/view_models/smart_contract_view_model.dart';

class CampaignCreator extends StatefulWidget {

  const CampaignCreator({super.key});
  @override
  _CampaignCreatorState createState() => _CampaignCreatorState();

}

class _CampaignCreatorState extends State<CampaignCreator> {
  SessionViewModel sessionData = SessionViewModel();
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
    createCampaign(jsonParameters['name'],jsonParameters['lat'],jsonParameters['lng'],jsonParameters['range']);
  }

  @override
  Widget build(BuildContext context) {

    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));

    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.green,
              size: 50.0,
            )));
  }

  Future<void> createCampaign(String name, int lat, int lng, int range) async {
    SmartContractViewModel smartContractViewModel = SmartContractViewModel();

    List<dynamic> result = await smartContractViewModel.query(
        FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),
        'createCampaign',
        [name, lat, lng, range]);
    print('|||||||||||||||||||||||||||||||||||||||||||| DEBUG ||||||||||||||||||||||||||||||||||||');
    print(result);
    print('|||||||||||||||||||||||||||||||||||||||||||| END ||||||||||||||||||||||||||||||||||||');
  }
}
