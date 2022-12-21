import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/join_campaign_factory.dart';
import '../../utils/styles.dart';
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
  bool activeSensor = false;
  bool gate = false;
  double sum = 0;

  List<double> lights = [];
  double averageRelevation = 0;

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));

    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Name: ',
                  style: CustomTextStyle.spaceMonoBold(context),
                ),
                Text(
                  '${campaignSelectedData['name']}',
                  style: CustomTextStyle.inconsolata(context),
                ),
              ],
            ),
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
            Center(
                child: TextButton(
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
                          gate = !gate;
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
                                              "This device doesen't integrate the appropriate sensor")));
                        });
                      }
                    },
                    child: const Text('Check Data',
                        style: TextStyle(color: Colors.white)))),
                (activeSensor && gate)
                ? StreamBuilder<double>(
                    stream: environmentSensors.light,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        lights.add(snapshot.data!);
                        sum += lights.last;
                        averageRelevation = double.parse(
                            (sum / lights.length).toStringAsFixed(2));
                        return Column(children: [
                          Row(children: [
                            Text('Average Ambient Light: ',
                                style: GoogleFonts.merriweather(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('$averageRelevation',
                                style: GoogleFonts.inconsolata(fontSize: 16))
                          ]),
                          Row(children: [
                            Text('Number of relevations: ',
                                style:
                                    CustomTextStyle.merriweatherBold(context)),
                            Text('${lights.length}',
                                style: CustomTextStyle.inconsolata(context))
                          ]),
                          Row(children: [
                            FloatingActionButton(
                                onPressed: () {},
                                backgroundColor: CustomColors.green600(context),
                                child: const Icon(Icons.check)),
                            FloatingActionButton(
                                onPressed: () {},
                                backgroundColor: CustomColors.red600(context),
                                child: const Icon(Icons.close)),
                          ]),
                        ]);
                      }
                    })
                : const Text(
                    "check data for get a relevation and compare the result")
          ]))
    ]));
  }
}
