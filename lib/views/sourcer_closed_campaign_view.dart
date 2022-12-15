import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import '../providers/smart_contract_provider.dart';
import '../utils/styles.dart';

class SourcerClosedCampaignView extends StatefulWidget {
  final List<dynamic>? contractAddress;

  const SourcerClosedCampaignView({Key? key, required this.contractAddress})
      : super(key: key);

  @override
  State<SourcerClosedCampaignView> createState() => _SourcerClosedCampaignViewState();
}

class _SourcerClosedCampaignViewState extends State<SourcerClosedCampaignView> {

  SessionViewModel sessionData = SessionViewModel();

  late List<String> contractsAddresses = [];
  late List<String> names = [];
  late List<String> latitude = [];
  late List<String> longitude = [];
  late List<String> range = [];
  late List<String> type = [];
  late List<String> addressCrowdSourcer = [];
  late List<String> fileCount = [];

  @override
  initState() {
    if (widget.contractAddress != null) {
      for (int i = 0; i < widget.contractAddress!.length; i++) {
        SmartContractProvider smartContractViewModel = SmartContractProvider(widget.contractAddress![i].toString(), 'Campaign', 'assets/abi_campaign.json', provider: sessionData.getProvider());
        smartContractViewModel.queryCall('getInfo', [], null).then((value) => {
          setState(() {
            if (value != null) {
              contractsAddresses.add(widget.contractAddress![i].toString());
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
  }

  @override
  Widget build(BuildContext context) {
    Text loadingText = Text(
      'LOADING...',
      style: CustomTextStyle.spaceMono(context),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Yours Past Campaigns'),
          centerTitle: true,
        ),
        body: (widget.contractAddress != null) ?
        Container(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          width: double.maxFinite,
          child: ListView.builder(
              itemCount: widget.contractAddress!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: (){
                      Navigator.pushReplacementNamed(context,'/data_campaign', arguments: {
                        'name': names[index],
                        'contractAddress': contractsAddresses[index],
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
                                    style: CustomTextStyle.spaceMono(context),
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  (longitude.length != widget.contractAddress!.length) ? loadingText : Text("Longitude: ${longitude[index]}",
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
                                    style: CustomTextStyle.spaceMono(context),
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
                                  (addressCrowdSourcer.length != widget.contractAddress!.length) ? loadingText : Column(
                                    //mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "crowdsourcer:",
                                        style: CustomTextStyle.spaceMono(context),
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
                                    style: CustomTextStyle.spaceMono(context),
                                  ),
                                ])
                              ])
                          ),

                        ],
                      ),
                    )
                 )
                );
              }),
        ) : const Center(child: Text('No active campaign at the moment...'))
    );
  }
}
