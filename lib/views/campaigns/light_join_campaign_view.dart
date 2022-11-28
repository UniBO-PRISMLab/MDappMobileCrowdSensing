import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';

import '../../models/ipfs_client_model.dart';
import '../../providers/upload_light_ipfs_privider.dart';
import '../../utils/helperfunctions.dart';
import '../../utils/join_campaign_factory.dart';
import '../dialog_view.dart';

class LightJoinCampaignView extends JoinCampaignFactory {
  const LightJoinCampaignView({super.key});

  @override
  LightJoinCampaignViewState createState() {
    return LightJoinCampaignViewState();
  }
}

class LightJoinCampaignViewState
    extends State<LightJoinCampaignView> {
  dynamic campaignSelectedData = {};
  Object? parameters;
  EnvironmentSensors environmentSensors = EnvironmentSensors();
  bool activeSensor = false;
  double sum = 0;

  List<double>lights = [];
  double averageRelevation = 0;

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    SessionViewModel sessionData = SessionViewModel();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Go to catch the Ambient Light'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                        style: GoogleFonts.merriweather(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${sessionData.getAccountAddress()}',
                        style: GoogleFonts.inconsolata(fontSize: 16),
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
                          Text(
                            'Latitude: ',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${campaignSelectedData['lat']}',
                            style: GoogleFonts.inconsolata(fontSize: 16),
                          ),
                          Text(
                            'Longitude: ',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${campaignSelectedData['lng']}',
                            style: GoogleFonts.inconsolata(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Range: ',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${campaignSelectedData['range']}',
                            style: GoogleFonts.inconsolata(fontSize: 16),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () async {
                            bool lightAvailable = await environmentSensors.getSensorAvailable(SensorType.Light);
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
                                const DialogView(message: "This device doesen't integrate the appropriate sensor")));
                              });
                            }
                          },
                          child: const Text('Take data')
                      ),
                activeSensor?
                StreamBuilder<double>(
                    stream: environmentSensors.light,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        lights.add(snapshot.data!);
                        sum += lights.last;
                        averageRelevation = double.parse((sum / lights.length).toStringAsFixed(2));
                        return Column(
                            children: [
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
                                    style: GoogleFonts.merriweather(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text('${lights.length}',
                                    style: GoogleFonts.inconsolata(
                                        fontSize: 16))
                              ]),
                              FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  UploadLightIpfsProvider(lights,averageRelevation)));
                                    setState(() {
                                      lights.clear();
                                      averageRelevation = 0;
                                      sum = 0;
                                      activeSensor = false;
                                    });
                                  }, child: const Icon(Icons.file_upload_sharp)),
                            ]);
                      }
                    }) :
                    const Text("NO DATA FOR THE MOMENT")
                ])
            )]
        )
      )
    );
  }
}
