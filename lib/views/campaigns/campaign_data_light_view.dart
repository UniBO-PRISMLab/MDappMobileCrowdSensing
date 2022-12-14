import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:tar/tar.dart';
import '../../providers/smart_contract_provider.dart';
import '../../utils/campaign_data_factory.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../utils/helperfunctions.dart';

class CampaignDataLightView extends CampaignDataFactory {
  const CampaignDataLightView({super.key});

  @override
  LightJoinCampaignViewState createState() {
    return LightJoinCampaignViewState();
  }
}

class LightJoinCampaignViewState extends State<CampaignDataLightView> {
  dynamic campaignSelectedData = {};
  Object? parameters;
  SessionViewModel sessionData = SessionViewModel();
  late SmartContractProvider smartContract = SmartContractProvider(campaignSelectedData['contractAddress'], 'Campaign', 'assets/abi_campaign.json', provider: sessionData.getProvider());
  late List<String> hashes = [];
  List<LightData> contents = [];

  _downloadFiles(hashToDownload) async {
    print("DEBUG ::::::::::::::::::::::::::::::::::::::: [getFileIPFSHash]: $hashToDownload");
    String? res = await downloadItemIPFS(hashToDownload,'lights');
    if (res != null) {
      List<String> value = res.split('/');
      contents.add(LightData(DateTime.fromMillisecondsSinceEpoch(int.parse(value[0])), double.parse(value[1])));
      hashes.add(hashToDownload);
    }
  }

  _preparePage() async {
    int lenght = 0;
    await clearTemporaryDirectory();
    List<dynamic>? fileCountRes = await smartContract.queryCall('fileCount', [], null);
    if (fileCountRes != null) {
      lenght = int.parse(fileCountRes[0].toString());
      for (int i = 0; i < lenght; i++) {
        List<dynamic>? allfilesPathRes = await smartContract.queryCall('allfilesPath', [BigInt.from(i)], null);
        if (allfilesPathRes?[0] != null) {
           await _downloadFiles(allfilesPathRes![0]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    _preparePage();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(campaignSelectedData['name']),
        ),
        body: (contents.isNotEmpty)?
          SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            child: Center(
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  series: <LineSeries<LightData, String>>[
                                    LineSeries<LightData, String>(
                                      // Bind data source
                                        dataSource:  contents,
                                        xValueMapper: (LightData sales, _) => DateFormat('dd/MM/yyyy, HH:mm').format(sales.timeStamp),
                                        yValueMapper: (LightData sales, _) => sales.value
                                    )
                                  ]
                              )
                            )
                          )
                  ])
            )
          ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text('No files for this Campaign', style: GoogleFonts.inconsolata(fontSize: 16),),
                  ),
                ])
        );
  }
}
class LightData {
  LightData(this.timeStamp, this.value);
  final DateTime timeStamp;
  final double value;
}
