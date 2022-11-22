import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/smart_contract_view_model.dart';

class SourcerCampaignView extends StatefulWidget {
  final List<dynamic>? contractAddress;

  const SourcerCampaignView({Key? key, required this.contractAddress})
      : super(key: key);

  @override
  State<SourcerCampaignView> createState() => _SourcerCampaignViewState();
}

class _SourcerCampaignViewState extends State<SourcerCampaignView> {
  late List<String> names = [];
  late List<String> latitude = [];
  late List<String> longitude = [];
  late List<String> range = [];
  late List<String> addressCrowdSourcer = [];
  late List<String> fileCount = [];

  @override
  initState() {
    if (widget.contractAddress != null) {
      for (int i = 0; i < widget.contractAddress!.length; i++) {
        SmartContractViewModel smartContractViewModel = SmartContractViewModel(
            widget.contractAddress![i].toString(),
            'Campaign',
            'assets/abi_campaign.json');

        smartContractViewModel
            .queryCall(context, 'name', [], null, null)
            .then((value) => {
                  setState(() {
                    names.add(value![0]);
                  })
                });

        smartContractViewModel
            .queryCall(context, 'lat', [], null, null)
            .then((value) => {
                  setState(() {
                    latitude.add((value![0]).toString());
                  })
                });

        smartContractViewModel
            .queryCall(context, 'lng', [], null, null)
            .then((value) => {
                  setState(() {
                    longitude.add((value![0]).toString());
                  })
                });

        smartContractViewModel
            .queryCall(context, 'range', [], null, null)
            .then((value) => {
                  setState(() {
                    range.add(value![0].toString());
                  })
                });

        smartContractViewModel
            .queryCall(context, 'addressCrowdSourcer', [], null, null)
            .then((value) => {
                  setState(() {
                    addressCrowdSourcer.add(value![0].toString());
                  })
                });

        smartContractViewModel
            .queryCall(context, 'fileCount', [], null, null)
            .then((value) => {
                  setState(() {
                    fileCount.add(value![0].toString());
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Your Campaigns'),
          centerTitle: true,
        ),
        body: (widget.contractAddress != null)
            ?
        Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                width: double.maxFinite,
                child: ListView.builder(
                    itemCount: widget.contractAddress!.length,
                    itemBuilder: (context, index) {
                      return Card(
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
                                child: Padding(padding: const EdgeInsets.only(left: 10, top: 5),
                                      child: Column(children: <Widget>[
                                        Row(children: <Widget>[
                                          //loop
                                          (names.length !=
                                                  widget.contractAddress!
                                                      .length)
                                              ? loadingText
                                              : Text(
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
                                                ),
                                        ]),
                                        Row(children: <Widget>[
                                          (latitude.length != widget.contractAddress!.length)
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
                                          (longitude.length != widget.contractAddress!.length) ? loadingText
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
                                        Row(children: <Widget>[
                                          (range.length != widget.contractAddress!.length) ? loadingText
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
                                          (addressCrowdSourcer.length != widget.contractAddress!.length)
                                              ? loadingText
                                              : Column(
                                                //mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  Text(addressCrowdSourcer[index],
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
                                                  widget.contractAddress!
                                                      .length)
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
                                      ])
                                  ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ) : const Center(child: Text('No active campaign at the moment...'))
    );
  }
}
