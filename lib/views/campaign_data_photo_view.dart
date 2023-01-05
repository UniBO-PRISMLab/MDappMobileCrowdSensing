import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import '../../utils/worker_campaign_data_factory.dart';
import '../models/validate_model.dart';
import '../models/verifier_campaign_data_model.dart';

class CampaignDataPhotoView extends WorkerDataCampaignFactory {
  const CampaignDataPhotoView({super.key});
  @override
  LightJoinCampaignViewState createState() {
    return LightJoinCampaignViewState();
  }
}

class LightJoinCampaignViewState extends State<CampaignDataPhotoView> {
  Object? parameters;
  dynamic jsonParameters = {};
  late String contractAddress;
  List<String> hashes = [];
  bool downloadGate = true;

  _prepareData(String hash) async {
    Stream<FileSystemEntity>? res =
        await ValidateModel.downloadPhotosFiles(hash);
    if (res != null) {
      res.forEach((element) {
        pictures.add(File(element.path));
      });
      if (kDebugMode) {
        print("PREPARING DATA: ${pictures.length}");
      }
      setState(() {});
    }
  }

  late List<File> pictures = [];

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    contractAddress = jsonParameters["contractAddress"];

    if (downloadGate) {
      VerifierCampaignDataModel.getDataFileInfo(contractAddress)
          .then((info) => {
                if (mounted && info != null)
                  {
                    setState(() {
                      for (dynamic i in info) {
                        _prepareData(i[3].toString());
                      }
                      downloadGate = !downloadGate;
                    })
                  }
              });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
          title: Text(jsonParameters["name"]),
          centerTitle: true,
        ),
        body: SizedBox (
          height: DeviceDimension.deviceHeight(context) * 0.6,
            child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: pictures.length,
            itemBuilder: (ctx, i) => (pictures.isEmpty
                ? const Text('Add some images')
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                        width: DeviceDimension.deviceWidth(context) * 0.9,
                        child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Image.file(pictures[i],
                                fit: BoxFit.cover))))))));
  }
}
