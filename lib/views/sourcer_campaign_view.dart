import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import '../providers/smart_contract_provider.dart';

class SourcerCampaignView extends StatefulWidget {
  final List<dynamic>? contractAddress;

  const SourcerCampaignView({Key? key, required this.contractAddress})
      : super(key: key);

  @override
  State<SourcerCampaignView> createState() => _SourcerCampaignViewState();
}

class _SourcerCampaignViewState extends State<SourcerCampaignView> {

  SessionViewModel sessionData = SessionViewModel();
  late List<String> names = [];
  late List<String> latitude = [];
  late List<String> longitude = [];
  late List<String> range = [];
  late List<String> type = [];
  late List<String> addressCrowdSourcer = [];
  late List<String> fileCount = [];

  @override
  initState() {
    if (widget.contractAddress![0].toString() != "0x0000000000000000000000000000000000000000") {
        SmartContractProvider smartContractViewModel = SmartContractProvider(widget.contractAddress![0].toString(), 'Campaign', 'assets/abi_campaign.json', provider: sessionData.getProvider());
        smartContractViewModel.queryCall('getInfo', [], null).then((value) => {
          setState(() {
            if (value != null) {
              names.add(value[0]);
              latitude.add(value[1].toString());
              longitude.add(value[2].toString());
              range.add(value[3].toString());
              type.add(value[4]);
              addressCrowdSourcer.add(value[5].toString());
              fileCount.add(value[6].toString());
            }
          })
        });
    }
    super.initState();
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
          title: const Text('Your Campaign'),
          centerTitle: true,
        ),
        body: (widget.contractAddress![0].toString() != "0x0000000000000000000000000000000000000000") ?
        Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                width: double.maxFinite,
                child: Column (
                    children: [
                  Text("Swipe right to close the campaign",style: GoogleFonts.spaceMono(
                      textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                      fontWeight: FontWeight.bold, fontSize: 20)),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.contractAddress!.length,
                      itemBuilder: (context, index) {
                      return Dismissible(
                        direction: DismissDirection.startToEnd,
                        confirmDismiss: (direction) {
                          return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text('Do you want to close this campaign?'),
                            actions: <Widget>[
                              TextButton(child: const Text('No'),onPressed: () {Navigator.of(ctx).pop(false);}),
                              TextButton(child: const Text('Yes'),onPressed: () {
                                Navigator.of(ctx).pop(true);
                                Navigator.pushReplacementNamed(context, "/sourcer_close_campaign_service_provider",arguments: {
                                  'address' : widget.contractAddress.toString(),
                                });

                              }),
                              ],
                          ),);
                        },
                        background: Container(
                          color: Colors.redAccent,
                          child: Row(

                            children: [
                              Text(
                              'CLOSE\nCAMPAIGN',
                              style: GoogleFonts.spaceMono(
                                  textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                            ),
                            ]),
                        ),
                        key: Key(index.toString()),
                        onDismissed: (direction) {
                          setState(() {
                            widget.contractAddress!.removeAt(index);
                            names.removeAt(index);
                            latitude.removeAt(index);
                            longitude.removeAt(index);
                            range.removeAt(index);
                            addressCrowdSourcer.removeAt(index);
                            fileCount.removeAt(index);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Campaign closed')));
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
                                                  widget.contractAddress!
                                                      .length)
                                              ? loadingText
                                              :
                                           Expanded(
                                             flex: 5,
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
                                          (type.length != widget.contractAddress!.length) ? loadingText
                                              : Text(
                                            "Type: ${type[index]}",
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
                                          (fileCount.length != widget.contractAddress!.length) ? loadingText :
                                          Text(
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

                            ],
                          ),
                        ),
                      ),
                      );
                    })
          ]),
              ) :  Center(
                child:
                  Text('No active campaign at the moment...',
                    style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, fontSize: 16),
                  )
        )
    );
  }
}
