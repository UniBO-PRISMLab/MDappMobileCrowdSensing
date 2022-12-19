import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';


class VerifierCampaignDataController extends StatefulWidget {

  const VerifierCampaignDataController({Key? key}) : super(key: key);

  @override
  State<VerifierCampaignDataController> createState() =>
      _VerifierCampaignDataControllerState();
}

class _VerifierCampaignDataControllerState extends State<VerifierCampaignDataController> {

  Object? parameters;
  dynamic jsonParameters = {};

  late String contractAddress;
  String fileCount = '0';
  String fileChecked = '0';
  String workersCount = '0';


  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));

    this.contractAddress = jsonParameters["contractAddress"];

    String name = jsonParameters['name'];
    String lat = jsonParameters['lat'];
    String lng = jsonParameters['lng'];
    String range = jsonParameters['range'];
    String type = jsonParameters['type'];
    String crowdsourcer = jsonParameters['crowdsourcer'];
    String contractAddress = jsonParameters['contractAddress'];
    String readebleLocation = jsonParameters['readebleLocation'];

    Text loadingText = Text(
      'LOADING...',
      style: CustomTextStyle.spaceMono(context),
    );

    return (contractAddress != "0x0000000000000000000000000000000000000000") ?
      Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                width: double.maxFinite,
                child: Column(children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: contractAddress.length,
                      itemBuilder: (context, index) {
                        return Card(
                            shadowColor: Colors.blue[600],
                            color: Colors.white54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Stack(children: <Widget>[
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(children: <Widget>[
                                        Row(children: <Widget>[
                                          //loop
                                          (name.isEmpty)
                                              ? loadingText
                                              : Expanded(
                                                  flex: 5,
                                                  child: Text("Name: $name",
                                                      style: CustomTextStyle
                                                          .spaceMono(context))),
                                        ]),
                                        Row(children: <Widget>[
                                          (lat.isEmpty)
                                              ? loadingText
                                              : Text(
                                                  "Latitude: $lat",
                                                  style: GoogleFonts.spaceMono(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              letterSpacing:
                                                                  .5),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16),
                                                ),
                                        ]),
                                        Row(children: <Widget>[
                                          (lng.isEmpty)
                                              ? loadingText
                                              : Text("Longitude: $lng",
                                                  style:
                                                      CustomTextStyle.spaceMono(
                                                          context)),
                                        ]),
                                        Column(children: <Widget>[
                                          (readebleLocation == null)
                                              ? loadingText
                                              : Text(
                                                  "Location: $readebleLocation",
                                                  style:
                                                      CustomTextStyle.spaceMono(
                                                          context),
                                                ),
                                        ]),
                                        Row(children: <Widget>[
                                          (range.isEmpty)
                                              ? loadingText
                                              : Text(
                                                  "Range: $range",
                                                  style:
                                                      CustomTextStyle.spaceMono(
                                                          context),
                                                ),
                                        ]),
                                        Row(children: <Widget>[
                                          (type.isEmpty)
                                              ? loadingText
                                              : Text(
                                                  "Type: $type",
                                                  style:
                                                      CustomTextStyle.spaceMono(
                                                          context),
                                                )
                                        ]),
                                        Flexible(
                                            flex: 5,
                                            child: Text(
                                              "Sourcing Status:\nuploaded $fileCount files\nchecked $fileChecked of $fileCount\nwhit the contribution of $workersCount workers",
                                              style: CustomTextStyle.spaceMono(
                                                  context),
                                            ))
                                      ]))
                                ])));
                      })
                ])) :
      Center(
          child: Text('No active campaign at the moment...', style: CustomTextStyle.spaceMono(context),));
  }
}
