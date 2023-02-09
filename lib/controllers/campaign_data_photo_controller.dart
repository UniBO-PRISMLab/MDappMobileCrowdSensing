import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/file_manager_model.dart';
import '../models/validate_model.dart';
import '../models/verifier_campaign_data_model.dart';
import '../utils/styles.dart';

class CampaignDataPhotoController extends StatefulWidget {
  const CampaignDataPhotoController({Key? key}) : super(key: key);

  @override
  State<CampaignDataPhotoController> createState() =>
      _CampaignDataPhotoControllerState();
}

class _CampaignDataPhotoControllerState
    extends State<CampaignDataPhotoController> {
  Object? parameters;
  dynamic jsonParameters = {};

  Future<List<File>> _getData(String contractAddress) async {
    late List<File> pictures = [];
    await FileManagerModel.clearTemporaryDirectory();
    List<dynamic>? res =
        await VerifierCampaignDataModel.getDataFileInfo(contractAddress);
    if (res != null) {
      for (dynamic i in res) {
        Stream<FileSystemEntity>? res = await ValidateModel.downloadPhotosFiles(i[4].toString());
        print("DEBUG DI CIRCOSTANZA :::::::::: ${res.toString()}");
        if (res != null) {
          res.forEach((element) async {
            File f = File(element.path);
            pictures.add(await f.create());
          });
        }
      }
    }
    return pictures;
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    String contractAddress = jsonParameters["contractAddress"];

    return FutureBuilder(
        future: _getData(contractAddress),
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  width: double.maxFinite,
                  child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                        CircularProgressIndicator(),
                      ]));
            default:
              return _galleryWidget(context, snapshot);
          }
        });
  }

  Widget _galleryWidget(
      BuildContext context, AsyncSnapshot<List<File>> snapshot) {

    return (snapshot.data!.isEmpty
        ? Center(
        child: Text('No images for this campaign.',
            style: CustomTextStyle.spaceMono(context)))
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) =>  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                        width: DeviceDimension.deviceWidth(context) * 0.9,
                        child:
                        Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Image.file(snapshot.data![i],
                                fit: BoxFit.cover))
                    )
            ))
    );
  }
}
