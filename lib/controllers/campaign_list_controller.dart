import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/campaign_list_model.dart';
import 'package:numberpicker/numberpicker.dart';
import '../models/db_capaign_model.dart';
import '../utils/styles.dart';
import '../models/search_places_model.dart';
import 'distance_controller.dart';

// ignore: must_be_immutable
class CampaignListController extends StatefulWidget {
  final List<dynamic> contractsAddresses;
  final String goTo;
  CampaignListController({super.key,required this.contractsAddresses, required this.goTo});
  SearchPlacesModel places = SearchPlacesModel();

  @override
  // ignore: library_private_types_in_public_api
  _CampaignListControllerState createState() =>
      _CampaignListControllerState();
}

class _CampaignListControllerState
    extends State<CampaignListController> {
  Future<dynamic> futureGetData() {
    return CampaignListModel.getData(widget.contractsAddresses);
  }

  Future<dynamic> futureGetPosition() async {
    await widget.places.updateLocalPosition();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([futureGetData(), futureGetPosition()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  width: double.maxFinite,
                  child: Column(children: [
                    _filtersWidget(),
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

  Widget _buildPage(BuildContext context, AsyncSnapshot snapshot) {
    return (snapshot.data[0].length > 0)
        ? Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            width: double.maxFinite,
            child: Column(children: [
              _filtersWidget(),
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data[0].length,
                    itemBuilder: (context, index) {
                      List? current = snapshot.data[0][index];
                      String? name,
                          lat,
                          lng,
                          range,
                          type,
                          crowdsourcer,
                          fileCount,
                          contractAddress,
                          readebleLocation,
                          isSubscribed,
                          balance;
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
                        balance = "${current[10].toString()} wei";
                        return GestureDetector(
                          onTap: () {

                            if(_checkIfDeviceIsInArea(lat!,lng!,range!)) {
                              Navigator.pushNamed(
                                  context, widget.goTo,
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
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    'Out of position',
                                    style: CustomTextStyle.spaceMonoWhite(context),
                                  )));
                            }
                          },
                          child: _cardWidget(
                              isSubscribed!,
                              contractAddress,
                              name!,
                              lat,
                              lng,
                              range,
                              type!,
                              fileCount,
                              crowdsourcer,
                              balance,
                              readebleLocation!),
                        );
                      } else {
                        return Container();
                      }
                    }),
              )
            ]))
        : Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
      width: double.maxFinite,
      child: Column(children: [
      Expanded(
      child:Center(
            child: Text(
            "No Campaign active at the moment.",
            style: CustomTextStyle.spaceMono(context),
          )))]));
  }

  Widget _cardWidget(
      String isSubscribed,
      String contractAddress,
      String name,
      String lat,
      String lng,
      String range,
      String type,
      String fileCount,
      String crowdsourcer,
      String balance,
      String readebleLocation) {
    return Card(
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
                    Flexible(
                    flex: 0,
                    child:Text("Name: ",
                        style: CustomTextStyle.spaceMonoBold(context))),
                    Flexible(
                        flex: 5,
                        child: Text(name,
                            style: CustomTextStyle.spaceMono(context))),
                    Flexible(flex: 1, child:Container()),
                    Flexible(
                        flex: 0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: (isSubscribed == 'true')
                                  ? MaterialStateProperty.all(
                                      CustomColors.red600(context))
                                  : MaterialStateProperty.all(
                                      CustomColors.green600(context))),
                          child: (isSubscribed == 'true')
                              ? const Text('unsubscribe')
                              : const Text('subscribe'),
                          onPressed: () async {
                            if (isSubscribed == 'true') {
                              await db.deleteCampaign(contractAddress);
                              //await removeTask(contractAddress);
                            } else {
                              await db.insertCampaign(Campaign(
                                  title: name,
                                  lat: lat,
                                  lng: lng,
                                  radius: range,
                                  address: contractAddress));
                              //await addPeriodicTask(name!,contractAddress);
                            }
                            setState(() {});
                          },
                        )),
                  ]),
                  Row(children: <Widget>[
                    Text(
                      "Latitude: $lat",
                      style: CustomTextStyle.spaceMono(context),
                    ),
                  ]),
                  Row(children: <Widget>[
                    Text(
                      "Longitude: $lng",
                      style: CustomTextStyle.spaceMono(context),
                    ),
                  ]),
                  Column(children: <Widget>[
                    Text("Location: $readebleLocation",
                        style: CustomTextStyle.spaceMono(context))
                  ]),
                  Row(children: <Widget>[
                    Text(
                      "Range: $range m",
                      style: CustomTextStyle.spaceMono(context),
                    ),
                  ]),
                  Row(children: <Widget>[
                    Text(
                      "Type: $type",
                      style: CustomTextStyle.spaceMono(context),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          "crowdsourcer:",
                          style: CustomTextStyle.spaceMono(context),
                        ),
                        FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              crowdsourcer,
                              style: CustomTextStyle.spaceMono(context),
                            )),
                      ],
                    ),
                  ),
                  Row(children: <Widget>[
                    Text(
                      "Balance: $balance",
                      style: CustomTextStyle.spaceMono(context),
                    ),
                  ]),
                  Row(children: <Widget>[
                    Text(
                      "fileCount: $fileCount",
                      style: CustomTextStyle.spaceMono(context),
                    ),
                  ])
                ])),
          ],
        ),
      ),
    );
  }

  Widget _filtersWidget() {
    return Row(children: [
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
      (selectedValue == "Near Me") ? _radiusPicker() : Container(),
    ]);
  }

  Widget _radiusPicker() {
    return Row(children: [
      Text(" radius: ", style: CustomTextStyle.spaceMono(context)),
      SizedBox(
          width: 50,
          child: NumberPicker(
            selectedTextStyle:
                TextStyle(fontSize: 18, color: CustomColors.blue900(context)),
            textStyle: const TextStyle(fontSize: 13),
            itemHeight: 18,
            value: _currentIntValue,
            minValue: 0,
            maxValue: 50,
            step: 2,
            haptics: true,
            onChanged: (value) => setState(() => _currentIntValue = value),
          )),
      Text("Km", style: CustomTextStyle.spaceMono(context)),
    ]);
  }

  bool _isToShow(dynamic data) {
    switch (selectedValue) {
      case "Subscribed":
        return (data[9] == "true") ? true : false;
      case "Near Me":
        dynamic distance = DistanceController.distanceBetween(
            (double.parse(data[1].toString()) / 10000000),
            (double.parse(data[2].toString()) / 10000000),
            widget.places.lat,
            widget.places.lng);
        if (kDebugMode) {
          print("DEBUG::::::::::::::::: [${double.parse(data[1].toString()) / 10000000},${double.parse(data[2].toString()) / 10000000}] e [${widget.places.lat},${widget.places.lng}] => $distance");
        }
        return (distance <= (_currentIntValue)) ? true : false;
      default:
        return true;
    }
  }

  bool _checkIfDeviceIsInArea(String lat, String lon, String range) {
    widget.places.updateLocalPosition();
    dynamic distanceInMeters = DistanceController.distanceBetween(widget.places.lat, widget.places.lng, double.parse(lat), double.parse(lon))*1000;
    return (distanceInMeters <= double.parse(range))? true : false;
  }
}
