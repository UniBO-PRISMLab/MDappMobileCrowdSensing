import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';

import '../../utils/join_campaign_factory.dart';

class TemperatureJoinCampaignView extends JoinCampaignFactory {
  const TemperatureJoinCampaignView({super.key});

  @override
  TemperatureJoinCampaignViewState createState() {
    return TemperatureJoinCampaignViewState();
  }
}

class TemperatureJoinCampaignViewState
    extends State<TemperatureJoinCampaignView> {
  dynamic campaignSelectedData = {};
  Object? parameters;

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));

    SessionViewModel sessionData = SessionViewModel();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Go to catch some Temperatures'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/temperature.png',
                height: 150,
                fit:BoxFit.fill,
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
                        ],),
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
                        ],),
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
                        ],),
                      TextButton(
                          onPressed: (){},
                          child: const Text('Take data')
                      )
                    ])
            )
          ],
        ),
      ),
    );
  }
}
