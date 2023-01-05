import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/worker_campaign_model.dart';
import '../utils/styles.dart';
import '../models/search_places_model.dart';
import '../models/session_model.dart';


class WorkerCampaignController extends StatelessWidget {

  List<dynamic>? contractsAddresses;

  WorkerCampaignController(this.contractsAddresses, {super.key});

  SessionModel sessionData = SessionModel();
  SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:WorkerCampaignModel.getData(contractsAddresses),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                  child: Text('Sorry something goes wrong...')
              );
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator(),);
            default:
              return _buildPage(context, snapshot);
          }
        });
  }

  // sta qui
  _buildPage(BuildContext context, AsyncSnapshot snapshot) {
    return (snapshot.data.length>0)?
    Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
      width: double.maxFinite,
      child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            List current = snapshot.data[index];

            String name = current[0];
            String lat = (int.parse(current[1].toString())/10000000).round().toString();
            String lng = (int.parse(current[2].toString())/10000000).round().toString();
            String range = current[3].toString();
            String type = current[4];
            String crowdsourcer = current[5].toString();
            String fileCount = current[6].toString();
            String contractAddress = current[7].toString();
            String readebleLocation = current[8];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/join_campaign',
                    arguments: {
                      'name': name,
                      'lat': lat,
                      'lng': lng,
                      'range': range,
                      'type': type,
                      'contractAddress': contractAddress,
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
                          alignment: Alignment.topLeft,
                          child: Column(children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                    "Name: $name",
                                    style: CustomTextStyle.spaceMono(context),
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
                              Text(
                                  "Location: $readebleLocation",
                                  style: CustomTextStyle.spaceMono(context))
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
                                        style:
                                        CustomTextStyle.spaceMono(context),
                                      )),
                                ],
                              ),
                            ),
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
              ),
            );
          }),
    ): Center(child:Text("No Campaign active at the moment.",style: CustomTextStyle.spaceMono(context),));
  }


}