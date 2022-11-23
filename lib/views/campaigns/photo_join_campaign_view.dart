import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/join_campaign_factory.dart';
import '../../view_models/session_view_model.dart';

class PhotoJoinCampaignView extends JoinCampaignFactory {
  const PhotoJoinCampaignView({super.key});

  @override
  TemperatureJoinCampaignViewState createState() {
    return TemperatureJoinCampaignViewState();
  }
}

class TemperatureJoinCampaignViewState extends State<PhotoJoinCampaignView> {

  dynamic campaignSelectedData = {};
  Object? parameters;

  @override
  Widget build(BuildContext context) {
    int counterFiles = 0;
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    SessionViewModel sessionData = SessionViewModel();

    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Go to catch some Photos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Circle-icons-camera.svg.png',
                height: 150,
                fit:BoxFit.fill
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
                            ' Longitude: ',
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

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/camera');
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 24.0,
                        ),
                        label: const Text('Take data'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                         // Navigator.pushNamed(context, '/camera');
                        },
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          size: 24.0,
                        ),
                        label: const Text('Delete data'),
                      ),
                      Row(
                        children: [
                          Text(
                            'Uploaded Files: ',
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '$counterFiles',
                            style: GoogleFonts.inconsolata(fontSize: 16),
                          ),
                        ],),
                       Center(
                         child:
                           FloatingActionButton(onPressed: (){}, child: const Icon(Icons.file_upload_sharp)),

                       ),
                    ])
            )
          ],
        ),
      ),
    );
  }
}
