import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/sourcer_campaign_model.dart';
import '../utils/styles.dart';

class SourcerCampaignController extends StatefulWidget {
  const SourcerCampaignController({Key? key}) : super(key: key);

  @override
  State<SourcerCampaignController> createState() =>
      _SourcerCampaignControllerState();
}

class _SourcerCampaignControllerState extends State<SourcerCampaignController> {
  Object? parameters;
  dynamic jsonParameters = {};
  dynamic jsonCounters = {};

  String fileCount = '0';
  String fileChecked = '0';
  String workersCount = '0';
  late String name ='',
      lat ='',
      lng ='',
      range ='',
      type ='',
      crowdsourcer ='',
      contractAddress ='',
      readebleLocation ='';

  _formatData(String contractAddress) async {
    if(mounted){
      String counters = await SourcerCampaignModel.getCountersData(contractAddress);
      jsonCounters = jsonDecode(counters);
      fileCount = jsonCounters['fileCount'].toString();
      fileChecked = jsonCounters['fileChecked'].toString();
      workersCount = jsonCounters['workersCount'].toString();
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
      parameters = ModalRoute
          .of(context)!
          .settings
          .arguments;
      jsonParameters = jsonDecode(jsonEncode(parameters));
      name = jsonParameters["name"];
      lat = jsonParameters["lat"];
      lng = jsonParameters["lng"];
      range = jsonParameters["range"];
      type = jsonParameters["campaignType"];
      crowdsourcer = jsonParameters["addressCrowdSourcer"];
      contractAddress = jsonParameters["contractAddress"];
      readebleLocation = jsonParameters["redebleLocation"];
      _formatData(contractAddress);
    return  _buildPage(context);
  }


  Widget _buildPage(context) {
    if (contractAddress != "0x0000000000000000000000000000000000000000" || contractAddress.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        width: double.maxFinite,
        child: Column(children: [
          Card(
            shadowColor: Colors.blue[600],
            color: Colors.white54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Column(children: <Widget>[
                        Row(children: <Widget>[
                          //loop
                          (name.isEmpty)
                              ? GlobalText.loadingText(context)
                              : Expanded(
                              flex: 5,
                              child: Text("Name: $name",
                                  style: CustomTextStyle.spaceMono(
                                      context))),
                        ]),
                        Row(children: <Widget>[
                          (lat.isEmpty)
                              ? GlobalText.loadingText(context)
                              : Text(
                            "Latitude: ${(int.parse(lat) / 10000000).round()}",
                            style: CustomTextStyle.spaceMono(context),
                          ),
                        ]),
                        Row(children: <Widget>[
                          (lng.isEmpty)
                              ? GlobalText.loadingText(context)
                              : Text(
                              "Longitude: ${(int.parse(lng) / 10000000).round()}",
                              style:
                              CustomTextStyle.spaceMono(context)),
                        ]),
                        Column(children: <Widget>[
                          (readebleLocation.isEmpty)
                              ? GlobalText.loadingText(context)
                              : Text(
                            "Location: $readebleLocation",
                            style: CustomTextStyle.spaceMono(context),
                          ),
                        ]),
                        Row(children: <Widget>[
                          (range.isEmpty)
                              ? GlobalText.loadingText(context)
                              : Text(
                            "Range: $range",
                            style: CustomTextStyle.spaceMono(context),
                          ),
                        ]),
                        Row(children: <Widget>[
                          (type.isEmpty)
                              ? GlobalText.loadingText(context)
                              : Text(
                            "Type: $type",
                            style: CustomTextStyle.spaceMono(context),
                          ),
                        ]),
                      ])),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 5,
              child: Text(
                "Sourcing Status:\nuploaded $fileCount files\nchecked $fileChecked of $fileCount\nwhit the contribution of $workersCount workers",
                style: CustomTextStyle.spaceMono(context),
              )),
          FloatingActionButton(
              backgroundColor: CustomColors.red600(context),
              child: Icon(Icons.close,color: CustomColors.customWhite(context),),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to close this campaign?'),
                    actions: <Widget>[
                      TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          }),
                      TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                            Navigator.popAndPushNamed(context,
                                "/sourcer_close_campaign_service_provider",
                                arguments: {
                                  'address': contractAddress.toString(),
                                });
                          }),
                    ],
                  ),
                );
              })
        ])
      );
    } else {
      return Center(child: Text(
        'No active campaign at the moment...',
        style: CustomTextStyle.spaceMono(context),
      ));
    }
  }
}


