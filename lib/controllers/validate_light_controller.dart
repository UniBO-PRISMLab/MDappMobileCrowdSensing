import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import '../../utils/join_campaign_factory.dart';
import '../../utils/styles.dart';
import '../models/validate_model.dart';
import '../utils/spalsh_screens.dart';
import '../views/dialog_view.dart';

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

  Widget _buildPage(hash)
  {
    return ListView(shrinkWrap: false, children: [
      Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
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
                Text('$relevation ',
                    style: CustomTextStyle.inconsolata(context)),
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
            ],
          )),
      const SizedBox(
        height: 20,
      ),
      Center(
          child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(CustomColors.blue900(context)),
                maximumSize: MaterialStateProperty.all(const Size(200, 40)),
              ),
              onPressed: () async {
                bool lightAvailable = await environmentSensors
                    .getSensorAvailable(SensorType.Light);
                if (lightAvailable) {
                  setState(() {
                    activeSensor = true;
                    sensorGate = !sensorGate;
                    sum = 0;
                    lights.clear();
                    averageRelevation = 0;
                  });
                } else {
                  setState(() {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const DialogView(
                                message:
                                    "This device doesn't integrate the appropriate sensor")));
                  });
                }
              },
              child: const Text('Check Data',
                  style: TextStyle(color: Colors.white)))),
      (activeSensor && sensorGate)
          ? StreamBuilder<double>(
              stream: environmentSensors.light,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  lights.add(snapshot.data!);
                  sum += lights.last;
                  averageRelevation =
                      double.parse((sum / lights.length).toStringAsFixed(2));
                  return Padding(
                      padding: EdgeInsets.only(
                        top: DeviceDimension.deviceHeight(context) * 0.15,
                        left: DeviceDimension.deviceWidth(context) * 0.09,
                      ),
                      child: Wrap(
                          alignment:
                              WrapAlignment.spaceAround, // set your alignment
                          children: [
                            Row(children: [
                              Text('Average Ambient Light: ',
                                  style: CustomTextStyle.merriweatherBold(
                                      context)),
                              Text('$averageRelevation',
                                  style: CustomTextStyle.inconsolata(context))
                            ]),
                            Row(children: [
                              Text('Number of relevations: ',
                                  style: CustomTextStyle.merriweatherBold(
                                      context)),
                              Text('${lights.length}',
                                  style: CustomTextStyle.inconsolata(context))
                            ]),
                            const SizedBox(
                              height: 50,
                            ),
                            FloatingActionButton(
                                heroTag: "verified",
                                onPressed: () async {
                                  bool res = await ValidateModel.approveOrNot(
                                      campaignSelectedData['contractAddress'],
                                      hash,
                                      true);
                                  if (res) {
                                    if (!mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      'Data verified',
                                      style: CustomTextStyle.spaceMonoWhite(
                                          context),
                                    )));
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/home',
                                            (Route<dynamic> route) => false);
                                  } else {
                                    if (!mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      'An Error occurred',
                                      style: CustomTextStyle.spaceMonoWhite(
                                          context),
                                    )));
                                  }
                                },
                                backgroundColor: CustomColors.green600(context),
                                child: const Icon(Icons.check)),
                            FloatingActionButton(
                                heroTag: "notVerified",
                                onPressed: () async {
                                  bool res = await ValidateModel.approveOrNot(
                                      campaignSelectedData['contractAddress'],
                                      hash,
                                      false);
                                  if (res) {
                                    if (!mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      'Data verified',
                                      style: CustomTextStyle.spaceMonoWhite(
                                          context),
                                    )));
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/home',
                                            (Route<dynamic> route) => false);
                                  } else {
                                    if (!mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      'An Error occurred',
                                      style: CustomTextStyle.spaceMonoWhite(
                                          context),
                                    )));
                                  }
                                },
                                backgroundColor: CustomColors.red600(context),
                                child: const Icon(Icons.close)),
                          ]));
                }
              })
          : const Center(
              child: Text(
                  "check data for get a relevation and compare the result"))
    ]);
  }
}
