import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/smart_contract_provider.dart';
import '../view_models/search_places_view_model.dart';
import '../view_models/session_view_model.dart';

class WorkerCampaignView extends StatefulWidget {
  final List<dynamic>? contractAddress;
  const WorkerCampaignView({Key? key, required this.contractAddress})
      : super(key: key);

  @override
  State<WorkerCampaignView> createState() => _WorkerCampaignViewState();
}

class _WorkerCampaignViewState extends State<WorkerCampaignView> {

  late List<String> contractsAddresses = [];
  late List<String> names = [];
  late List<String> latitude = [];
  late List<String> longitude = [];
  late List<String?> readebleLocation = [];
  late List<String> range = [];
  late List<String> type = [];
  late List<String> addressCrowdSourcer = [];
  late List<String> fileCount = [];
  SessionViewModel sessionData = SessionViewModel();
  SearchPlacesViewModel searchPlacesViewModel = SearchPlacesViewModel();
  @override
  initState() {
    if (widget.contractAddress != null) {
      for (int i = 0; i < widget.contractAddress!.length; i++) {
        SmartContractProvider smartContractViewModel = SmartContractProvider(widget.contractAddress![i].toString(),'Campaign','assets/abi_campaign.json', provider: sessionData.getProvider());
        String? readebleLocationQuery;
        smartContractViewModel.queryCall('getInfo', [], null).then((value) async => {
                  readebleLocationQuery = await searchPlacesViewModel.getReadebleLocationFromLatLng((double.parse(value![1].toString()))/10000000,(double.parse(value[2].toString()))/10000000),
                  setState(() {
                    contractsAddresses.add(widget.contractAddress![i].toString());
                    names.add(value[0]);
                    latitude.add(value[1].toString());
                    longitude.add(value[2].toString());
                    readebleLocation.add(readebleLocationQuery);
                    range.add(value[3].toString());
                    type.add(value[4]);
                    addressCrowdSourcer.add(value[5].toString());
                    fileCount.add(value[6].toString());
                  })
            });
      }

      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    Text loadingText = Text(
      'LOADING...',
      style: GoogleFonts.spaceMono(
          textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
          fontWeight: FontWeight.bold,
          fontSize: 16),
    );
    setState(() {});
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('List Of All Campaigns'),
          centerTitle: true,
        ),
        body: (widget.contractAddress != null) ?
        Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                width: double.maxFinite,
                child: ListView.builder(
                    itemCount: widget.contractAddress!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.pushReplacementNamed(context,'/join_campaign', arguments: {
                            'name': names[index],
                            'contractAddress': contractsAddresses[index],
                            'lat': latitude[index].toString(),
                            'lng': longitude[index].toString(),
                            'range': range[index].toString(),
                            'type' : type[index],
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
                                        //loop
                                        (names.length !=
                                                widget
                                                    .contractAddress!.length)
                                            ? loadingText
                                            : Expanded(
                                              child: Text(
                                                      "Name: ${names[index]}",
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
                                                    )
                                              ),
                                      ]),
                                      Row(children: <Widget>[
                                        (latitude.length !=
                                                widget
                                                    .contractAddress!.length)
                                            ? loadingText
                                            : Text(
                                                "Latitude: ${latitude[index]}",
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
                                        (longitude.length !=
                                                widget
                                                    .contractAddress!.length)
                                            ? loadingText
                                            : Text(
                                                "Longitude: ${longitude[index]}",
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
                                      Column(children: <Widget>[
                                        (readebleLocation.length != widget.contractAddress!.length)
                                            ? loadingText
                                            : Text("Location: ${readebleLocation[index]}",
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
                                        (range.length !=
                                                widget
                                                    .contractAddress!.length)
                                            ? loadingText
                                            : Text(
                                                "Range: ${range[index]}",
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
                                        (range.length !=
                                            widget
                                                .contractAddress!.length)
                                            ? loadingText
                                            : Text(
                                          "Type: ${type[index]}",
                                          style: GoogleFonts.spaceMono(
                                              textStyle:
                                              const TextStyle(color: Colors.black87, letterSpacing: .5),
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 16),
                                        ),
                                      ]),


                                      Row(children: <Widget>[
                                        (addressCrowdSourcer.length !=
                                                widget
                                                    .contractAddress!.length)
                                            ? loadingText
                                            : Column(
                                                //mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "crowdsourcer:",
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
                                                  Text(
                                                    addressCrowdSourcer[
                                                        index],
                                                    style: GoogleFonts.spaceMono(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                letterSpacing:
                                                                    .5),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                      ]),
                                      Row(children: <Widget>[
                                        (fileCount.length !=
                                                widget
                                                    .contractAddress!.length)
                                            ? loadingText
                                            : Text(
                                                "fileCount: ${fileCount[index]}",
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
                                      ])
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            : const Center(child: Text('No active campaign at the moment...')));
  }
}
