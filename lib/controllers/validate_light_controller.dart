import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import '../../utils/join_campaign_factory.dart';
import '../../utils/styles.dart';
import '../models/validate_model.dart';
import '../utils/spalsh_screens.dart';
import 'light_sensor_controller.dart';

class ValidateLightController extends JoinCampaignFactory {
  const ValidateLightController({super.key});

  @override
  ValidateLightControllerState createState() {
    return ValidateLightControllerState();
  }
}

class ValidateLightControllerState extends State<ValidateLightController> {
  dynamic campaignSelectedData = {};
  Object? parameters;
  EnvironmentSensors environmentSensors = EnvironmentSensors();
  bool activeSensor = false, sensorGate = false;

  double sum = 0, averageRelevation = 0;
  late String? time = "Loading...", relevation = "Loading...";
  late List fileInfo = [];
  late List data = [];
  List<double> lights = [];

  _prepareData(String hash, String contractAddress) async {
    data = await ValidateModel.downloadLightFiles(hash);
    fileInfo = await ValidateModel.getFileData(hash, contractAddress);
    time = DateTime.fromMillisecondsSinceEpoch(int.parse(data[0])).toString();
    relevation = double.parse(data[1]).toString();
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    String hash = campaignSelectedData['ipfsHash'];
    String contractAddress = campaignSelectedData["contractAddress"];

    return FutureBuilder(
        future: _prepareData(hash, contractAddress),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return CustomSplashScreen.fadingCubeBlueBg(context);
            default:
              return _buildPage(hash);
          }
        });
  }

  Widget _buildPage(hash) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Text(
            'ipfs hash: ',
            style: CustomTextStyle.spaceMonoBold(context),
          ),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '${campaignSelectedData['ipfsHash']}',
                style: CustomTextStyle.inconsolata(context),
              )),
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            Text('Average Data Collected: ',
                style: CustomTextStyle.merriweatherBold(context)),
            Text('$relevation ', style: CustomTextStyle.inconsolata(context)),
          ]),
          Row(children: [
            Text('On: ', style: CustomTextStyle.merriweatherBold(context)),
            Text('$time', style: CustomTextStyle.inconsolata(context)),
          ]),
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            Text('Latitude: ',
                style: CustomTextStyle.merriweatherBold(context)),
            Text('${double.parse(fileInfo[5].toString()) / 10000000}',
                style: CustomTextStyle.inconsolata(context)),
          ]),
          Row(children: [
            Text('Longitude: ',
                style: CustomTextStyle.merriweatherBold(context)),
            Text('${double.parse(fileInfo[6].toString()) / 10000000}',
                style: CustomTextStyle.inconsolata(context)),
          ]),
          const LightSensorController()
        ])
    );
  }
}
