import 'dart:convert';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/geofence_model.dart';
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
  bool isUpload = true;
  double sum = 0;

  List<double> lights = [];
  double averageRelevation = 0;
  late Geofence geo;

  @override
  void dispose() {
    geo.stopGeofenceService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    SessionModel sessionData = SessionModel();

    geo = Geofence(campaignSelectedData['name'], campaignSelectedData['contractAddress'], campaignSelectedData['lat'], campaignSelectedData['lng'], campaignSelectedData['range']);
    geo.geoFenceService(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
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
                        Text('Name: ',
                            style: CustomTextStyle.merriweatherBold(context)),
                        Text(
                          '${campaignSelectedData['name']}',
                          style: CustomTextStyle.inconsolata(context),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Latitude: ',
                            style: CustomTextStyle.merriweatherBold(context)),
                        Text('${campaignSelectedData['lat']}',
                            style: CustomTextStyle.inconsolata(context)),
                        Text('Longitude: ',
                            style: CustomTextStyle.merriweatherBold(context)),
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
                          style: CustomTextStyle.merriweatherBold(context),
                        ),
                        Text(
                          '${campaignSelectedData['range']} m',
                          style: CustomTextStyle.inconsolata(context),
                        ),
                      ],
                    ),
                    Center(
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    CustomColors.blue900(context))),
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
                            child: Text(
                              'Take data',
                              style: CustomTextStyle.spaceMonoWhite(context),
                            ))),
                    activeSensor
                        ? StreamBuilder<double>(
                            stream: environmentSensors.light,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                lights.add(snapshot.data!);
                                sum += lights.last;
                                averageRelevation = double.parse(
                                    (sum / lights.length).toStringAsFixed(2));
                                return Column(children: [
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
                                  (isUpload)?
                                  FloatingActionButton(
                                      onPressed: () async {
                                        setState(() {
                                          isUpload = false;
                                        });
                                        String? res =
                                        await UploadIpfsModel.uploadLight(
                                            lights,
                                            averageRelevation,
                                            campaignSelectedData[
                                            'contractAddress']);
                                        setState(() {
                                          activeSensor = false;
                                          isUpload = true;
                                          if (res != null) {
                                            if (res == 'Data uploaded') {
                                              lights.clear();
                                              averageRelevation = 0;
                                              sum = 0;
                                              if(!mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                'Data uploaded',
                                                style: CustomTextStyle
                                                    .spaceMonoWhite(context),
                                              )));
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      '/home',
                                                      (Route<dynamic> route) =>
                                                          false);
                                            } else {
                                              lights.clear();
                                              averageRelevation = 0;
                                              sum = 0;
                                              if(!mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                res,
                                                style: CustomTextStyle
                                                    .spaceMonoWhite(context),
                                              )));
                                            }
                                          } else {
                                            lights.clear();
                                            averageRelevation = 0;
                                            sum = 0;
                                            if(!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                              'Unhandled Error.',
                                              style: CustomTextStyle
                                                  .spaceMonoWhite(context),
                                            )));
                                          }
                                        });
                                      },
                                      backgroundColor:
                                          CustomColors.blue900(context),
                                      child:
                                          const Icon(Icons.file_upload_sharp))
                                      : const Center(child: CircularProgressIndicator())
                                ]);
                              }
                            })
                        : const Text("NO DATA FOR THE MOMENT")
                  ]))
        ])));
  }
}
