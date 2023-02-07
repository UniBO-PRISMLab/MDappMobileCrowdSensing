import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import '../models/verifier_campaign_data_model.dart';

class VerifierCampaignDataController extends StatefulWidget {
  final String goTo;
  const VerifierCampaignDataController({Key? key, required this.goTo}) : super(key: key);

  @override
  State<VerifierCampaignDataController> createState() =>
      _VerifierCampaignDataPhotoController();
}

class _VerifierCampaignDataPhotoController
    extends State<VerifierCampaignDataController> {
  Object? parameters;
  dynamic jsonParameters = {};
  dynamic jsonCounters = {};
  List<dynamic>? filesInfo;

  String fileCount = '0';
  String fileChecked = '0';
  String workersCount = '0';
  late String name,
      lat,
      lng,
      range,
      type,
      crowdsourcer,
      contractAddress,
      readebleLocation;

  Future<void> _formatData() async {
    String counters = await _getContractData();
    filesInfo = await _getDataFile();
    jsonCounters = jsonDecode(counters);
    fileCount = jsonCounters['fileCount'].toString();
    fileChecked = jsonCounters['fileChecked'].toString();
    workersCount = jsonCounters['workersCount'].toString();
  }

  Future<String> _getContractData() {
    return VerifierCampaignDataModel.getData(contractAddress);
  }

  Future<List?> _getDataFile() {
    return VerifierCampaignDataModel.getDataFileInfo(contractAddress);
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    contractAddress = jsonParameters["contractAddress"];
    name = jsonParameters['name'];
    lat = jsonParameters['lat'];
    lng = jsonParameters['lng'];
    range = jsonParameters['range'];
    type = jsonParameters['type'];
    crowdsourcer = jsonParameters['crowdsourcer'];
    readebleLocation = jsonParameters['readebleLocation'];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      width: double.maxFinite,
      child:
      Column(children: [
        Column(children: <Widget>[
          Text("contractAddress:",
              style: CustomTextStyle.spaceMonoBold(context)),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(contractAddress,
                  style: CustomTextStyle.spaceMono(context))),
        ]),
        Column(children: <Widget>[
          Text("Crowdsourcer:", style: CustomTextStyle.spaceMonoBold(context)),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(crowdsourcer,
                  style: CustomTextStyle.spaceMono(context))),
        ]),
        Column(children: <Widget>[
          Text("Location:", style: CustomTextStyle.spaceMonoBold(context)),
          Text(readebleLocation, style: CustomTextStyle.spaceMono(context)),
        ]),
        Row(children: <Widget>[
          Text(
            "Range: ",
            style: CustomTextStyle.spaceMonoBold(context),
          ),
          Text(
            "$range m",
            style: CustomTextStyle.spaceMono(context),
          ),
          Text(
            "Type: ",
            style: CustomTextStyle.spaceMonoBold(context),
          ),
          Text(
            type,
            style: CustomTextStyle.spaceMono(context),
          ),
        ]),
        FutureBuilder(
            future: _formatData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Expanded(
                      flex: 1,
                      child:Center(
                          child: Text('Sorry something goes wrong...')));
                case ConnectionState.waiting:
                  return const Expanded(
                    flex: 1,
                    child: Center(
                        child: CircularProgressIndicator()),
                  );
                default:
                  return _bottomWidget();
              }
            }),
      ]),
    );
  }

  Widget _bottomWidget() {
    return Expanded(
        flex: 1,
        child: Column(children: [
          Text(
            "uploaded $fileCount files\nchecked $fileChecked of $fileCount",
            style: CustomTextStyle.spaceMonoBold(context),
          ),
          ListView.builder(
            //scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (filesInfo != null) ? filesInfo!.length : 0,
              itemBuilder: (context, index) {
                List current = filesInfo![index];

                String status = current[0].toString();
                String validity = current[1].toString();
                String uploader = current[2].toString();
                String ipfsHash = current[4].toString();
                if (status == 'false') {
                  return GestureDetector(
                    onTap: () {
                      if(SessionModel().getAccountAddress().toLowerCase() != uploader.toLowerCase()) {
                        Navigator.pushNamed(context, widget.goTo,
                            arguments: {
                              "name": name,
                              "ipfsHash": ipfsHash,
                              "uploader": uploader,
                              "contractAddress": contractAddress
                            });
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            content: Text(
                              "You can't verify your own Uploads",
                              style: CustomTextStyle.spaceMonoWhite(context),
                            )));
                      }
                    },
                    child: Card(
                      shadowColor: CustomColors.blue600(context),
                      color: CustomColors.customWhite(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Stack(children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: <Widget>[
                                  FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Column(children: [
                                        Text(
                                          "Uploader: ",
                                          style: CustomTextStyle.spaceMonoBold(
                                              context),
                                        ),
                                        Text(
                                          uploader,
                                          style: CustomTextStyle.spaceMono(
                                              context),
                                        )
                                      ])),
                                  FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Column(children: [
                                        Text(
                                          "Ipfs hash: ",
                                          style: CustomTextStyle.spaceMonoBold(
                                              context),
                                        ),
                                        Text(
                                          ipfsHash,
                                          style: CustomTextStyle.spaceMono(
                                              context),
                                        )
                                      ])),
                                ],
                              ),
                            ),
                          ])),
                    ),
                  );
                } else {
                  return Card(
                    shadowColor: (validity == 'true')
                        ? CustomColors.green600(context)
                        : CustomColors.red600(context),
                    color: CustomColors.customWhite(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: <Widget>[
                            FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Column(children: [
                                  Text(
                                    "Uploader: ",
                                    style:
                                    CustomTextStyle.spaceMonoBold(context),
                                  ),
                                  Text(
                                    uploader,
                                    style: CustomTextStyle.spaceMono(context),
                                  )
                                ])),
                            FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Column(children: [
                                  Text(
                                    "Ipfs hash: ",
                                    style:
                                    CustomTextStyle.spaceMonoBold(context),
                                  ),
                                  Text(
                                    ipfsHash,
                                    style: CustomTextStyle.spaceMono(context),
                                  )
                                ])),
                            FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(children: [
                                  Text(
                                    "validity: ",
                                    style:
                                    CustomTextStyle.spaceMonoBold(context),
                                  ),
                                  Text(
                                    validity,
                                    style: CustomTextStyle.spaceMono(context),
                                  )
                                ])),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              })
        ]));
  }
}
