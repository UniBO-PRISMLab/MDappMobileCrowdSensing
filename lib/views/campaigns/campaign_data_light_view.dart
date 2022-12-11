import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
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
  late SmartContractProvider smartContractViewModel;
  List<FileSystemEntity> files = [];
  late List<String> hashes;
  List<LightData> contents = [];
  void _getHashAndDownload(int index) async {
    List<dynamic>? res = await smartContractViewModel.queryCall('allfilesPath', [BigInt.from(index)], null);
    print("DEBUG ::::::::::::::::::::::::::::::::::::::: [getFileIPFSHash]: $res");
    hashes.add(res![0]);
    downloadItemIPFS(res[0],'lights');
  }

  Future<int> _getFileCount() async {
    List<dynamic>? res =
        await smartContractViewModel.queryCall('fileCount', [], null);
    print(
        "DEBUG ::::::::::::::::::::::::::::::::::::::: [getFileCount]: ${res.toString()}");
    return int.parse(res![0].toString());
  }

  void _prepareFiles() async{
    for(FileSystemEntity element in files) {
      String singleData = await File(element.path).readAsString();
      List<String> value = singleData.split("/");
      contents.add(LightData(DateTime.fromMillisecondsSinceEpoch(int.parse(value[0])), double.parse(value[1])));
    }
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
      _getFileCount().then((fileCount) => {
        for (int i = 0; i < fileCount; i++) {
          _getHashAndDownload
        },
        files = getDownloadedFiles('lights'),
        _prepareFiles()
      });
    });
    print("DEBUG ::::::::::::::::::::::::::::::::::::::: [initState-Hashes]: ${hashes.toString()}");

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(campaignSelectedData['name']),
        ),
        body: (files.isNotEmpty)?
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
          )
              : Column(
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
