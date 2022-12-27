import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import '../models/upload_ipfs_model.dart';
import '../utils/join_campaign_factory.dart';
import '../utils/styles.dart';
import 'dialog_view.dart';

class LightJoinCampaignView extends JoinCampaignFactory {
  const LightJoinCampaignView({super.key});

  @override
  LightJoinCampaignViewState createState() {
    return LightJoinCampaignViewState();
  }
}

class LightJoinCampaignViewState extends State<LightJoinCampaignView> {
  dynamic campaignSelectedData = {};
  Object? parameters;

  EnvironmentSensors environmentSensors = EnvironmentSensors();
  bool activeSensor = false;
  double sum = 0;

  List<double> lights = [];
  double averageRelevation = 0;

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    SessionModel sessionData = SessionModel();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Go to catch the Ambient Light'),
        ),
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/light.png',
            height: 150,
            fit: BoxFit.fill,
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: CustomTextStyle.merriweatherBold(context),
                    ),
                    Text(
                      '${sessionData.getAccountAddress()}',
                      style: CustomTextStyle.inconsolata(context),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Name: ',
                          style: GoogleFonts.merriweather(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '${campaignSelectedData['name']}',
                          style: GoogleFonts.inconsolata(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Latitude: ',
                            style: CustomTextStyle.merriweatherBold(context)),
                        Text(
                            '${(campaignSelectedData['lat'] * 10000000).round()}',
                            style: CustomTextStyle.inconsolata(context)),
                        Text('Longitude: ',
                            style: CustomTextStyle.merriweatherBold(context)),
                        Text(
                          '${(campaignSelectedData['lng'] * 10000000).round()}',
                          style: GoogleFonts.inconsolata(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Range: ',
                          style: CustomTextStyle.merriweatherBold(context),
                        ),
                        Text(
                          '${campaignSelectedData['range']}',
                          style: CustomTextStyle.inconsolata(context),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () async {
                          bool lightAvailable = await environmentSensors
                              .getSensorAvailable(SensorType.Light);
                          if (lightAvailable) {
                            setState(() {
                              activeSensor = true;
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
                        child: const Text('Take data')),
                    activeSensor
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text('$averageRelevation',
                                        style: GoogleFonts.inconsolata(
                                            fontSize: 16))
                                  ]),
                                  Row(children: [
                                    Text('Number of relevations: ',
                                        style: CustomTextStyle.merriweatherBold(
                                            context)),
                                    Text('${lights.length}',
                                        style: CustomTextStyle.inconsolata(
                                            context))
                                  ]),
                                  FloatingActionButton(
                                      onPressed: () async {
                                        String? res =
                                            await UploadIpfsModel.uploadLight(
                                                lights,
                                                averageRelevation,
                                                campaignSelectedData[
                                                    'contractAddress']);

                                        if (res != null) {
                                          if (res == 'Data uploaded') {
                                            setState(() {
                                              lights.clear();
                                              averageRelevation = 0;
                                              sum = 0;
                                              activeSensor = false;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                'Data uploaded',
                                                style: CustomTextStyle
                                                    .spaceMonoWhite(context),
                                              )));
                                              Navigator.pushReplacementNamed(
                                                  context, '/worker');
                                            });
                                          }
                                          setState(() {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                              res,
                                              style: CustomTextStyle
                                                  .spaceMonoWhite(context),
                                            )));
                                          });
                                        } else {
                                          setState(() {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                              'Unhandled Error.',
                                              style: CustomTextStyle
                                                  .spaceMonoWhite(context),
                                            )));
                                          });
                                        }
                                      },
                                      child:
                                          const Icon(Icons.file_upload_sharp)),
                                ]);
                              }
                            })
                        : const Text("NO DATA FOR THE MOMENT")
                  ]))
        ])));
  }
}
