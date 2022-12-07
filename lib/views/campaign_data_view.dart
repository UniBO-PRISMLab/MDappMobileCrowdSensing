import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import '../../utils/join_campaign_factory.dart';
import '../providers/smart_contract_provider.dart';

class CampaignDataView extends JoinCampaignFactory {
  const CampaignDataView({super.key});

  @override
  LightJoinCampaignViewState createState() {
    return LightJoinCampaignViewState();
  }
}

class LightJoinCampaignViewState extends State<CampaignDataView> {
  dynamic campaignSelectedData = {};
  Object? parameters;
  SessionViewModel sessionData = SessionViewModel();
  late SmartContractProvider smartContractViewModel;
  List<String> hashes = [];

  void _getFileIPFSHash(int index) async {
    List<dynamic>? res = await smartContractViewModel.queryCall(
        'allfilesPath', [BigInt.from(index)], null);
    print(
        "DEBUG ::::::::::::::::::::::::::::::::::::::: [getFileIPFSHash]: $res");
    hashes.add(res![0]);
  }

  Future<int> getFileCount() async {
    List<dynamic>? res =
        await smartContractViewModel.queryCall('fileCount', [], null);
    print(
        "DEBUG ::::::::::::::::::::::::::::::::::::::: [getFileCount]: ${res.toString()}");
    return int.parse(res![0].toString());
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    smartContractViewModel = SmartContractProvider(
        campaignSelectedData['contractAddress'],
        'Campaign',
        'assets/abi_campaign.json',
        provider: sessionData.getProvider());
    setState(() {
      getFileCount().then((fileCount) => {
            for (int i = 0; i < fileCount; i++) {_getFileIPFSHash}
          });
    });
    print(
        "DEBUG ::::::::::::::::::::::::::::::::::::::: [initState-Hashes]: ${hashes.toString()}");

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(campaignSelectedData['name']),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: (hashes.isNotEmpty)
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Account',
                    style: GoogleFonts.merriweather(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${sessionData.getAccountAddress()}',
                    style: GoogleFonts.inconsolata(fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    width: double.maxFinite,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: hashes.length,
                        itemBuilder: (context, index) {
                          return Card(
                              shadowColor: Colors.blue[600],
                              color: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Stack(children: <Widget>[
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(children: <Widget>[
                                          Text(hashes[index])
                                        ]))
                                  ])));
                        }),
                  )
                ])
              : Center(
                  child: Text(
                    'No files for this Campaign',
                    style: GoogleFonts.inconsolata(fontSize: 16),
                  ),
                ),
        )));
  }
}
