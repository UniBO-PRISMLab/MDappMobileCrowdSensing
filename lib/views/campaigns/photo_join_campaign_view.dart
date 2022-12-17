import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/join_campaign_factory.dart';
import '../../utils/styles.dart';
import '../camera_view.dart';
import '../../models/session_model.dart';

class PhotoJoinCampaignView extends JoinCampaignFactory {
  const PhotoJoinCampaignView({super.key});

  @override
  PhotoJoinCampaignViewState createState() {
    return PhotoJoinCampaignViewState();
  }
}

class PhotoJoinCampaignViewState extends State<PhotoJoinCampaignView> {

  dynamic campaignSelectedData = {};
  Object? parameters;
  List<Image> pictures = [];

  @override
  Widget build(BuildContext context) {
    int counterFiles = pictures.length;
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    SessionModel sessionData = SessionModel();
    int _index = 0;

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
                        ],),
                      Row(
                        children: [
                          Text(
                            'Latitude: ',
                            style: CustomTextStyle.merriweatherBold(context),
                          ),
                          Text(
                            '${campaignSelectedData['lat']}',
                            style: CustomTextStyle.inconsolata(context),
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
                            style: CustomTextStyle.merriweatherBold(context),
                          ),
                          Text(
                            '${campaignSelectedData['range']}',
                            style: CustomTextStyle.inconsolata(context),
                          ),
                        ],),

                      ElevatedButton.icon(
                        onPressed: () async {

                            pictures = await Navigator.of(context).push(
                                MaterialPageRoute(builder: (
                                    context) => const DataCollectionCameraView()));
                            setState(()  {
                            print("DEBUG::::::::::::::::::::::::::::::::::::: NUMBER OF PHOTOS: ${pictures.length}");
                          });
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 24.0,
                        ),
                        label: const Text('Take data'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          pictures.clear();
                          setState(() {
                            print("DEBUG::::::::::::::::::::::::::::::::::::: PHOTOS CLEARED: ${pictures.length}");
                          });

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
                            'Waiting Files: ',
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

                      Center(
                        child: SizedBox(
                          height: 200, // card height
                          child: PageView.builder(
                            itemCount: pictures.length,
                            controller: PageController(viewportFraction: 0.7),
                            onPageChanged: (int index) => setState(() => _index = index),
                            itemBuilder: (_, i) {
                              return Transform.scale(
                                scale: i == _index ? 1 : 0.9,
                                child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: Center(child: pictures[i])
                                      ),
                              );}
                          ),
                        ),
                      ),
                    ])
            )
          ],
        ),
      ),
    );
  }
}
