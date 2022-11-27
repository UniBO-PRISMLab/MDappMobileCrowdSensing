import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';

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
  final environmentSensors = EnvironmentSensors();

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    SessionViewModel sessionData = SessionViewModel();
    List<double> ligths = [];
    int numberOfRelevations = 10;
    double avreageRelevation = 0;
    bool activeSensor = false;
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
                                        builder: (BuildContext context) => const DialogView(message: "This device doesen't integrate the appropriate sensor")));
                              });
                            }
                          },
                          child: const Text('Take data')),
                      (activeSensor == true)?
                        StreamBuilder<double>(
                            stream: environmentSensors.light,
                            builder: (context, snapshot) {

                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                return Row(children: [
                                  Text(
                                    'Average Ambient Light: ',
                                    style: GoogleFonts.merriweather(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '$avreageRelevation',
                                    style: GoogleFonts.inconsolata(
                                        fontSize: 16),
                                  )
                                ]);
                              }
                            }) : Text(
                                  'Sensor deactivated',
                                  style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                                  ),
                ])
            )]
        )
      )
    );
  }
}
