import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/models/verifier_campaign_model.dart';
import '../models/backgorund_service_model.dart';
import '../models/db_capaign_model.dart';
import '../utils/styles.dart';
import '../models/search_places_model.dart';
import '../models/session_model.dart';

// ignore: must_be_immutable

class VerifierCampaignController extends StatefulWidget {
  List<dynamic>? contractsAddresses;
  VerifierCampaignController(this.contractsAddresses, {super.key});
  SessionModel sessionData = SessionModel();
  SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();


  @override
  _VerifierCampaignControllerState createState() =>
      _VerifierCampaignControllerState();
}

class _VerifierCampaignControllerState extends State<VerifierCampaignController> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: VerifierCampaignModel.getData(widget.contractsAddresses),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return _buildPage(context, snapshot);
          }
        });
  }

  String selectedValue = 'photo';
  DbCampaignModel db = DbCampaignModel();


  _buildPage(BuildContext context, AsyncSnapshot snapshot) {
    return (snapshot.data.length > 0)
        ? Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            width: double.maxFinite,
            child: Column(children: [
              DropdownButton(
                  value: selectedValue,
                  items: const [
                    DropdownMenuItem(
                      value: 'photo',
                      child: Text("Photos"),
                    ),
                    DropdownMenuItem(
                      value: 'light',
                      child: Text("Ambient Light"),
                    ),
                  ],
                  onChanged: (value) {
                    (context as Element).markNeedsBuild();
                    setState(() {
                      selectedValue = value as String;
                    });
                  }),
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List? current = snapshot.data[index];
                      String? name,
                          lat,
                          lng,
                          range,
                          type,
                          crowdsourcer,
                          fileCount,
                          contractAddress,
                          readebleLocation,
                          isSubscribed;
                      if (current != null) {
                        name = current[0];
                        lat = current[1].toString();
                        lng = current[2].toString();
                        range = current[3].toString();
                        type = current[4];
                        crowdsourcer = current[5].toString();
                        fileCount = current[6].toString();
                        contractAddress = current[7].toString();
                        readebleLocation = current[8];
                        isSubscribed = current[9];
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/verifier_campaign_data',
                              arguments: {
                                'contractAddress': contractAddress,
                                'name': name,
                                'readebleLocation': readebleLocation,
                                'type': type,
                                'crowdsourcer': crowdsourcer,
                                'range': range,
                                'lat': lat,
                                'lng': lng,
                              });
                        },
                        child: Card(
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
                                    alignment: Alignment.topRight,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: (isSubscribed ==
                                                  'true')
                                              ? MaterialStateProperty.all(
                                                  CustomColors.red600(context))
                                              : MaterialStateProperty.all(
                                                  CustomColors.green600(
                                                      context))),
                                      child: (isSubscribed == 'true')
                                          ? const Text('unsubscribe')
                                          : const Text('subscribe'),
                                      onPressed: () async {
                                        if (isSubscribed == 'true') {
                                          await db.deleteCampaign(contractAddress!);
                                          //await removeTask(contractAddress);
                                        } else {
                                          await db.insertCampaign(Campaign(name, lat, lng, address: contractAddress!));
                                          //await addPeriodicTask(name!,contractAddress);
                                        }
                                        setState(() {});
                                      },
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          "Name: $name",
                                          style: CustomTextStyle.spaceMono(
                                              context),
                                        )),
                                      ]),
                                      Row(children: <Widget>[
                                        Text(
                                          "Latitude: ${(int.parse(lat!) / 10000000).round()}",
                                          style: CustomTextStyle.spaceMono(
                                              context),
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        Text(
                                          "Longitude: ${(int.parse(lng!) / 10000000).round()}",
                                          style: CustomTextStyle.spaceMono(
                                              context),
                                        ),
                                      ]),
                                      Column(children: <Widget>[
                                        Text("Location: $readebleLocation",
                                            style: CustomTextStyle.spaceMono(
                                                context))
                                      ]),
                                      Row(children: <Widget>[
                                        Text(
                                          "Range: $range",
                                          style: GoogleFonts.spaceMono(
                                              textStyle: const TextStyle(
                                                  color: Colors.black87,
                                                  letterSpacing: .5),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        Text(
                                          "Type: $type",
                                          style: CustomTextStyle.spaceMono(
                                              context),
                                        ),
                                      ]),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "crowdsourcer:",
                                              style: CustomTextStyle.spaceMono(
                                                  context),
                                            ),
                                            FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  (crowdsourcer != null)
                                                      ? crowdsourcer
                                                      : "null",
                                                  style:
                                                      CustomTextStyle.spaceMono(
                                                          context),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Row(children: <Widget>[
                                        Text(
                                          "fileCount: $fileCount",
                                          style: CustomTextStyle.spaceMono(
                                              context),
                                        ),
                                      ])
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ]))
        : Center(
            child: Text(
            "No Campaign active at the moment.",
            style: CustomTextStyle.spaceMono(context),
          ));
  }
}
