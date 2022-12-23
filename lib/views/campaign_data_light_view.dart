import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import '../models/file_manager_model.dart';
import '../models/ipfs_client_model.dart';
import '../models/smart_contract_model.dart';
import '../utils/worker_campaign_data_factory.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../utils/styles.dart';

class CampaignDataLightView extends WorkerDataCampaignFactory {
  const CampaignDataLightView({super.key});

  @override
  LightJoinCampaignViewState createState() {
    return LightJoinCampaignViewState();
  }
}

class LightJoinCampaignViewState extends State<CampaignDataLightView> {
  dynamic campaignSelectedData = {};
  Object? parameters;
  SessionModel sessionData = SessionModel();
  late SmartContractModel smartContract = SmartContractModel(campaignSelectedData['contractAddress'], 'Campaign', 'assets/abi_campaign.json', provider: sessionData.getProvider());
  late List<String> hashes = [];
  List<LightData> contents = [];

  @override
  initState(){
    super.initState();
    FileManagerModel.clearTemporaryDirectory();
  }

  _downloadFiles(hashToDownload) async {
    print("DEBUG ::::::::::::::::::::::::::::::::::::::: [getFileIPFSHash]: $hashToDownload");
    String? res = await IpfsClientModel.downloadItemIPFS(hashToDownload,'lights');
    if (res != null) {
      List<String> value = res.split('/');
      if (mounted) {
        setState(() {
          contents.add(LightData(
              DateTime.fromMillisecondsSinceEpoch(int.parse(value[0])),
              double.parse(value[1])));
          hashes.add(hashToDownload);
        });
      }
    }
  }

  _preparePage() async {
    List<dynamic>? allfilesPathRes = await smartContract.queryCall('getValidFiles', [], null);
    if (allfilesPathRes != null) {
      print("CHECK this: ${allfilesPathRes[0]}");
      for (dynamic element in allfilesPathRes[0]) {
        print('element: '+ element);
        _downloadFiles(element);
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
                            style: CustomTextStyle.merriweatherBold(context),
                          ),
                          Text(
                            '${sessionData.getAccountAddress()}',
                            style: CustomTextStyle.inconsolata(context),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                            width: double.maxFinite,
                            child: Center(
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  series: <LineSeries<LightData, String>>[
                                    LineSeries<LightData, String>(
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
