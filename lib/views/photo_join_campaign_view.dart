import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/geofence_model.dart';
import '../models/upload_ipfs_model.dart';
import '../utils/join_campaign_factory.dart';
import '../utils/styles.dart';
import 'camera_view.dart';
import '../models/session_model.dart';
import 'dart:io';

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
  List<File> pictures = [];
  bool gate = true;
  bool visible = false;
  late Geofence geo;


  @override
  void dispose() {
    geo.stopGeofenceService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic space = DeviceDimension.deviceWidth(context) * 0.05;

    int counterFiles = pictures.length;
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    SessionModel sessionData = SessionModel();

    geo = Geofence(campaignSelectedData['name'], campaignSelectedData['contractAddress'], campaignSelectedData['lat'], campaignSelectedData['lng'], campaignSelectedData['range']);
    geo.geoFenceService(context);

    (pictures.isNotEmpty) ? visible = true : visible = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.blue900(context),
        centerTitle: true,
        title: const Text('Go to catch some Photos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/Circle-icons-camera.svg.png',
                height: 150, fit: BoxFit.fill),
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
                          Text('Name: ',
                              style: CustomTextStyle.spaceMonoBold(context)),
                          Text(
                            '${campaignSelectedData['name']}',
                            style: CustomTextStyle.inconsolata(context),
                          ),
                        ],
                      ),
                      Row(children: [
                        Text(
                          'Latitude: ',
                          style: CustomTextStyle.spaceMonoBold(context),
                        ),
                        Text(
                          '${campaignSelectedData['lat']}',
                          style: CustomTextStyle.inconsolata(context),
                        ),
                      ]),
                      Row(
                        children: [
                          Text('Longitude: ',
                              style: CustomTextStyle.spaceMonoBold(context)),
                          Text(
                            '${campaignSelectedData['lng']}',
                            style: CustomTextStyle.inconsolata(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Range: ',
                            style: CustomTextStyle.spaceMonoBold(context),
                          ),
                          Text(
                            '${campaignSelectedData['range']} m',
                            style: CustomTextStyle.inconsolata(context),
                          ),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.all(space),
                          height: 100,
                          child: Row(children: [
                            Expanded(
                                child: SizedBox(
                                    height: 100,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  CustomColors.blue900(
                                                      context))),
                                      onPressed: () async {
                                        pictures = await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const DataCollectionCameraView()));
                                        setState(() {
                                          if (kDebugMode) {
                                            print(
                                                "DEBUG::::::::::::::::::::::::::::::::::::: NUMBER OF PHOTOS: ${pictures.length}");
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 24.0,
                                      ),
                                      label: const Text('Take data'),
                                    ))),
                            Expanded(
                                child: Container(
                                    padding: EdgeInsets.only(left: space),
                                    height: 100,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  CustomColors.blue900(
                                                      context))),
                                      onPressed: () {
                                        if (pictures.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                            'No photos to delete',
                                            style:
                                                CustomTextStyle.spaceMonoWhite(
                                                    context),
                                          )));
                                        } else {
                                          pictures.clear();
                                        }
                                        setState(() {
                                          if (kDebugMode) {
                                            print(
                                                "DEBUG::::::::::::::::::::::::::::::::::::: PHOTOS CLEARED: ${pictures.length}");
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_outlined,
                                        size: 24.0,
                                      ),
                                      label: const Text('Delete data'),
                                    ))),
                          ])),
                      Row(
                        children: [
                          Text(
                            'Waiting Files: ',
                            style: CustomTextStyle.spaceMonoBold(context),
                          ),
                          Text(
                            '$counterFiles',
                            style: CustomTextStyle.inconsolata(context),
                          ),
                        ],
                      ),
                      Center(
                        child: SizedBox(
                          height: 200, // card height
                          child: PageView.builder(
                              itemCount: pictures.length,
                              controller: PageController(viewportFraction: 0.7),
                              onPageChanged: (int index) =>
                                  setState(() => index = index),
                              itemBuilder: (_, i) {
                                return Transform.scale(
                                  scale: 1,
                                  child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image.file(pictures[i],
                                          fit: BoxFit.cover)),
                                );
                              }),
                        ),
                      ),
                      (visible)
                          ? (gate)
                              ? Center(
                                  child: FloatingActionButton(
                                      backgroundColor:
                                          CustomColors.blue900(context),
                                      onPressed: () async {
                                        setState(() {
                                          gate = false;
                                        });
                                        String? res =
                                            await UploadIpfsModel.uploadPhotos(
                                                pictures,
                                                campaignSelectedData[
                                                    'contractAddress']);

                                        if (res != null) {
                                          if (res == 'Data uploaded') {
                                            setState(() {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                res,
                                                style: CustomTextStyle
                                                    .spaceMonoWhite(context),
                                              )));
                                              geo.stopGeofenceService();
                                              Navigator.of(context).pushNamedAndRemoveUntil(
                                                  '/home', (Route<dynamic> route) => false);
                                            });
                                          } else {
                                            setState(() {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                res,
                                                style: CustomTextStyle
                                                    .spaceMonoWhite(context),
                                              )));
                                              gate = true;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                              'Unhandled Error.',
                                              style: CustomTextStyle
                                                  .spaceMonoWhite(context),
                                            )));
                                            gate = true;
                                          });
                                        }
                                      },
                                      child:
                                          const Icon(Icons.file_upload_sharp)),
                                )
                              : const Center(child: CircularProgressIndicator())
                          : Container()
                    ]))
          ],
        ),
      ),
    );
  }
}
