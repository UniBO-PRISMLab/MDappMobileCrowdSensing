import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/models/verifier_campaign_model.dart';
import 'package:numberpicker/numberpicker.dart';
import '../models/db_capaign_model.dart';
import '../utils/styles.dart';
import '../models/search_places_model.dart';
import '../models/session_model.dart';

class VerifierCampaignController extends StatefulWidget {
  List<dynamic>? contractsAddresses;
  VerifierCampaignController(this.contractsAddresses, {super.key});
  SessionModel sessionData = SessionModel();
  SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();

  @override
  _VerifierCampaignControllerState createState() =>
      _VerifierCampaignControllerState();
}

class _VerifierCampaignControllerState
    extends State<VerifierCampaignController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: VerifierCampaignModel.getData(widget.contractsAddresses),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  width: double.maxFinite,
                  child: Column(children: [
                    Row(children: [
                      Text(
                        "filters: ",
                        style: CustomTextStyle.spaceMono(context),
                      ),
                      DropdownButton(
                          value: selectedValue,
                          items: const [
                            DropdownMenuItem(
                              value: 'All Campaigns',
                              child: Text("All Campaigns"),
                            ),
                            DropdownMenuItem(
                              value: 'Near Me',
                              child: Text("Near Me"),
                            ),
                            DropdownMenuItem(
                              value: 'Subscribed',
                              child: Text("Subscribed"),
                            ),
                          ],
                          onChanged: (value) {
                            (context as Element).markNeedsBuild();
                            setState(() {
                              selectedValue = value as String;
                            });
                          }),
                      (selectedValue == "Near Me")?
                      Column(children: [
                        NumberPicker(
                          itemHeight: 18,
                          value: _currentIntValue,
                          minValue: 0,
                          maxValue: 100,
                          step: 10,
                          haptics: true,
                          onChanged: (value) => setState(() => _currentIntValue = value),
                        ),
                      ])
                          :
                      Container(),
                    ]),
                    Expanded(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                          CircularProgressIndicator(),
                        ]))
                  ]));
            default:
              return _buildPage(context, snapshot);
          }
        });
  }
  int _currentIntValue = 10;
  String selectedValue = 'All Campaigns';
  DbCampaignModel db = DbCampaignModel();

  _buildPage(BuildContext context, AsyncSnapshot snapshot) {
    return (snapshot.data.length > 0)
        ? Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            width: double.maxFinite,
            child: Column(children: [
              Row(children: [
                Text(
                  "filters: ",
                  style: CustomTextStyle.spaceMono(context),
                ),
                DropdownButton(
                    value: selectedValue,
                    items: const [
                      DropdownMenuItem(
                        value: 'All Campaigns',
                        child: Text("All Campaigns"),
                      ),
                      DropdownMenuItem(
                        value: 'Near Me',
                        child: Text("Near Me"),
                      ),
                      DropdownMenuItem(
                        value: 'Subscribed',
                        child: Text("Subscribed"),
                      ),
                    ],
                    onChanged: (value) {
                      (context as Element).markNeedsBuild();
                      setState(() {
                        selectedValue = value as String;
                      });
                    }),
                (selectedValue == "Near Me")?
                    Column(children: [
                      NumberPicker(
                        itemHeight: 18,
                        value: _currentIntValue,
                        minValue: 0,
                        maxValue: 100,
                        step: 10,
                        haptics: true,
                        onChanged: (value) => setState(() => _currentIntValue = value),
                      ),
                    ])
                    :
                Container(),
              ]),
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
                      if (current != null && _isToShow(current)) {
                        name = current[0];
                        lat = (int.parse(current[1].toString()) / 10000000)
                            .toString();
                        lng = (int.parse(current[2].toString()) / 10000000)
                            .toString();
                        range = current[3].toString();
                        type = current[4];
                        crowdsourcer = current[5].toString();
                        fileCount = current[6].toString();
                        contractAddress = current[7].toString();
                        readebleLocation = current[8];
                        isSubscribed = current[9];
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
                                            backgroundColor:
                                                (isSubscribed == 'true')
                                                    ? MaterialStateProperty.all(
                                                        CustomColors.red600(
                                                            context))
                                                    : MaterialStateProperty.all(
                                                        CustomColors.green600(
                                                            context))),
                                        child: (isSubscribed == 'true')
                                            ? const Text('unsubscribe')
                                            : const Text('subscribe'),
                                        onPressed: () async {
                                          if (isSubscribed == 'true') {
                                            await db.deleteCampaign(
                                                contractAddress!);
                                            //await removeTask(contractAddress);
                                          } else {
                                            await db.insertCampaign(Campaign(
                                                title: name!,
                                                lat: lat!,
                                                lng: lng!,
                                                radius: range!,
                                                address: contractAddress!));
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
                                            "Latitude: $lat",
                                            style: CustomTextStyle.spaceMono(
                                                context),
                                          ),
                                        ]),
                                        Row(children: <Widget>[
                                          Text(
                                            "Longitude: $lng",
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
                                                style:
                                                    CustomTextStyle.spaceMono(
                                                        context),
                                              ),
                                              FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    (crowdsourcer != null)
                                                        ? crowdsourcer
                                                        : "null",
                                                    style: CustomTextStyle
                                                        .spaceMono(context),
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
                      } else {
                        return Container();
                      }
                    }),
              )
            ]))
        : Center(
            child: Text(
            "No Campaign active at the moment.",
            style: CustomTextStyle.spaceMono(context),
          ));
  }

  bool _isToShow(dynamic data) {
    switch (selectedValue) {
      case "Subscribed":
        return (data[9] == "true") ? true : false;
      case "Near Me":
        return data[9];
      default:
        return true;
    }
  }
}
