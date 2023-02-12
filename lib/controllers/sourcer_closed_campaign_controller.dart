import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../models/smart_contract_model.dart';
import '../utils/styles.dart';

class SourcerClosedCampaignController extends StatefulWidget {
  final List? contractAddress;
  const SourcerClosedCampaignController(this.contractAddress,{Key? key}) : super(key: key);

  @override
  State<SourcerClosedCampaignController> createState() => _SourcerClosedCampaignControllerState();
}

class _SourcerClosedCampaignControllerState extends State<SourcerClosedCampaignController> {

  SessionModel sessionData = SessionModel();

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
        SmartContractModel smartContractViewModel = SmartContractModel(contractAddress: widget.contractAddress![i].toString(),abiName: 'Campaign',abiFileRoot: 'assets/abi_campaign.json', provider: sessionData.getProvider());
        smartContractViewModel.queryCall('getInfo', []).then((value) => {
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
    return Container(
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
                    shadowColor: CustomColors.blue600(context),
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
                                FittedBox( fit: BoxFit.contain,child:
                                    Row(children: <Widget>[
                                  //loop
                                  (names.length != widget.contractAddress!.length)
                                      ? GlobalText.loadingText(context)
                                      : Text(
                                    "Name: ${names[index]}",
                                    style: CustomTextStyle.spaceMono(context),
                                  ),
                                ])),
                                Row(children: <Widget>[
                                  (latitude.length != widget.contractAddress!.length)
                                      ? GlobalText.loadingText(context)
                                      : Text(
                                    "Latitude: ${(int.parse(latitude[index].toString())/10000000)}",
                                    style: CustomTextStyle.spaceMono(context),
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  (longitude.length != widget.contractAddress!.length) ? GlobalText.loadingText(context) : Text("Longitude: ${(int.parse(longitude[index].toString())/10000000)}",
                                    style: CustomTextStyle.spaceMono(context),
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  (range.length != widget.contractAddress!.length) ? GlobalText.loadingText(context)
                                      : Text(
                                    "Range: ${range[index]} m",
                                    style: CustomTextStyle.spaceMono(context),
                                  ),
                                ]),

                                Row(children: <Widget>[
                                  (type.length != widget.contractAddress!.length) ? GlobalText.loadingText(context)
                                      : Text(
                                    "Type: ${type[index]}",
                                    style: CustomTextStyle.spaceMono(context),
                                  ),
                                ]),

                                Row(children: <Widget>[
                                  (fileCount.length != widget.contractAddress!.length) ? GlobalText.loadingText(context)
                                      : Text(
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
    );
  }
}
