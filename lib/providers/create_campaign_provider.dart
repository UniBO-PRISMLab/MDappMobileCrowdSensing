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
    SmartContractViewModel smartContractViewModel = SmartContractViewModel();
    List args = [name, lat, lng, range];
    print('|||||||||||||||||||||||||||||||||||||||||||| DEBUG INPUT ||||||||||||||||||||||||||||||||||||');
    print(args);
    print('|||||||||||||||||||||||||||||||||||||||||||| END INPUT ||||||||||||||||||||||||||||||||||||');
    List<dynamic> result = await smartContractViewModel.query(context,FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'), 'createCampaign', args, value);
    print('|||||||||||||||||||||||||||||||||||||||||||| DEBUG OUTPUT ||||||||||||||||||||||||||||||||||||');
    print(result);
    print('|||||||||||||||||||||||||||||||||||||||||||| END OUTPUT ||||||||||||||||||||||||||||||||||||');
  }
}
