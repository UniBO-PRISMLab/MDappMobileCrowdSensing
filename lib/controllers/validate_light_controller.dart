import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import '../../utils/join_campaign_factory.dart';
import '../../utils/styles.dart';
import '../models/validate_model.dart';
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
  bool activeSensor = false, sensorGate = false, downloadGate = false;

  double sum = 0, averageRelevation = 0;
  late String? hash, time, relevation;
  late List? data;
  List<double> lights = [];

  _prepareData() async {
    data = await ValidateModel.downloadLightFiles(hash);
    downloadGate = !downloadGate;
    time = DateTime.fromMillisecondsSinceEpoch(int.parse(data![0])).toString();
    relevation = double.parse(data![1]).toString();
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    hash = campaignSelectedData['ipfsHash'];
    if (hash != null && !downloadGate) {
      _prepareData();
    }
    return ListView(
        shrinkWrap: false,
        children: [
                Column(
                  children: [
                    Text(
                      'ipfs hash: ',
                      style: CustomTextStyle.spaceMonoBold(context),
                    ),
                    Text(
                      '${campaignSelectedData['ipfsHash']}',
                      style: CustomTextStyle.inconsolata(context),
                    ),
                  ],
                ),
                Center(child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.blue900(context)),
                          maximumSize:
                              MaterialStateProperty.all(const Size(200, 40)),
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
                                      builder: (BuildContext context) =>
                                          const DialogView(
                                              message:
                                                  "This device doesn't integrate the appropriate sensor")));
                            });
                          }
                        },
                        child: const Text('Check Data',
                            style: TextStyle(color: Colors.white)))),
            (activeSensor && sensorGate) ?
                 StreamBuilder<double>(

                    stream: environmentSensors.light,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        lights.add(snapshot.data!);
                        sum += lights.last;
                        averageRelevation = double.parse(
                            (sum / lights.length).toStringAsFixed(2));
                        return Padding(
                            padding: EdgeInsets.only(
                              top: DeviceDimension.deviceHeight(context) * 0.15,
                              left: DeviceDimension.deviceWidth(context) * 0.09,
                            ),
                            child: Wrap(
                                alignment: WrapAlignment
                                    .spaceAround, // set your alignment
                                children: [
                                  Row(children: [
                                    Text('Average Ambient Light: ',
                                        style: CustomTextStyle.merriweatherBold(
                                            context)),
                                    Text('$averageRelevation',
                                        style: CustomTextStyle.inconsolata(
                                            context))
                                  ]),
                                  Row(children: [
                                    Text('Number of relevations: ',
                                        style: CustomTextStyle.merriweatherBold(
                                            context)),
                                    Text('${lights.length}',
                                        style: CustomTextStyle.inconsolata(
                                            context))
                                  ]),
                                  Row(children: [
                                    Text('Average Relevation: ',
                                        style: CustomTextStyle.merriweatherBold(
                                            context)),
                                    Text('$relevation ',
                                        style: CustomTextStyle.inconsolata(
                                            context)),
                                  ]),
                                  Row(children: [
                                    Text(' On: ',
                                        style: CustomTextStyle.merriweatherBold(
                                            context)),
                                    Text('$time',
                                        style: CustomTextStyle.inconsolata(
                                            context)),
                                  ]),
                                  FloatingActionButton(
                                      heroTag: "verified",
                                      onPressed: () async {
                                        bool res = await ValidateModel.approveOrNot(campaignSelectedData['contractAddress'], hash, true);
                                        if(res) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                'Data verified',
                                                style: CustomTextStyle.spaceMonoWhite(context),
                                              )));
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                'An Error occurred',
                                                style: CustomTextStyle.spaceMonoWhite(context),
                                              )));
                                        }
                                      },
                                      backgroundColor:
                                          CustomColors.green600(context),
                                      child: const Icon(Icons.check)),
                                  FloatingActionButton(
                                      heroTag: "notVerified",
                                      onPressed: () async {
                                        bool res = await ValidateModel.approveOrNot(campaignSelectedData['contractAddress'], hash, false);
                                        if(res) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                'Data verified',
                                                style: CustomTextStyle.spaceMonoWhite(context),
                                              )));
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                'An Error occurred',
                                                style: CustomTextStyle.spaceMonoWhite(context),
                                              )));
                                        }
                                      },
                                      backgroundColor:
                                          CustomColors.red600(context),
                                      child: const Icon(Icons.close)),
                                ]));
                      }
                    })
                : const Text(
                    "check data for get a relevation and compare the result")
          ]);
  }
}
