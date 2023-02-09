import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/join_campaign_factory.dart';
import '../../utils/styles.dart';
import '../models/validate_model.dart';

class ValidatePhotoController extends JoinCampaignFactory {
  const ValidatePhotoController({super.key});

  @override
  ValidatePhotoState createState() {
    return ValidatePhotoState();
  }
}

class ValidatePhotoState extends State<ValidatePhotoController> {
  dynamic campaignSelectedData = {};
  Object? parameters;

  bool downloadGate = true;
  late List<File> pictures = [];
  late List<dynamic> fileData = [];
  Future<dynamic>? _prepareData() async {
    if (mounted) {
      pictures.clear();
      Stream<FileSystemEntity>? res = await ValidateModel.downloadPhotosFiles(
          campaignSelectedData['ipfsHash']);
      if (res != null) {
        res.forEach((FileSystemEntity element) async {
          File f = File(element.path);
          pictures.add(await f.create());
        });
        fileData = await ValidateModel.getFileData(campaignSelectedData['ipfsHash'],campaignSelectedData['contractAddress']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("validate_photo_controller");
    }

    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));

    return FutureBuilder(
        future: _prepareData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ]);
            default:
              return _buildPage();
          }
        });
  }

  Widget _buildPage() {
    return (pictures.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(shrinkWrap: false, children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'ipfs hash: ',
                    style: CustomTextStyle.spaceMonoBold(context),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '${campaignSelectedData['ipfsHash']}',
                      style: CustomTextStyle.inconsolata(context),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children:[
                      Text(
                          'This data was taken in',
                          style: CustomTextStyle.spaceMonoBold(context)),
                      Row(children: [
                        Text(
                            'Latitude: ',
                            style: CustomTextStyle.spaceMonoBold(context)),
                        Text(
                          '${(int.parse(fileData[5].toString()) / 10000000)}',
                          style: CustomTextStyle.inconsolata(context),)
                      ],),
                      Row(children: [
                        Text(
                            'Longitude: ',
                            style: CustomTextStyle.spaceMonoBold(context)),
                        Text(
                          '${(int.parse(fileData[6].toString()) / 10000000)}',
                          style: CustomTextStyle.inconsolata(context),)
                      ],),
                      Text(
                          'Address: ',
                          style: CustomTextStyle.spaceMonoBold(context)),
                      Text(
                      '${fileData[7]}',
                      style: CustomTextStyle.inconsolata(context),
                    ),
                  ])
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: DeviceDimension.deviceHeight(context) * 0.15,
                    left: DeviceDimension.deviceWidth(context) * 0.09,
                  ),
                  child: Wrap(
                      alignment:
                          WrapAlignment.spaceAround, // set your alignment
                      children: [
                        Row(children: [
                          Text('Number of photos: ',
                              style: CustomTextStyle.merriweatherBold(context)),
                          Text('${pictures.length}',
                              style: CustomTextStyle.inconsolata(context))
                        ]),
                        Center(
                          child: SizedBox(
                            height: 200, // card height
                            child: PageView.builder(
                                itemCount: pictures.length,
                                controller:
                                    PageController(viewportFraction: 0.7),
                                onPageChanged: (int index) =>
                                    setState(() => index = index),
                                itemBuilder: (_, i) {
                                  return Transform.scale(
                                    scale: 1,
                                    child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Image.file(pictures[i],
                                            fit: BoxFit.cover)),
                                  );
                                }),
                          ),
                        ),
                        FloatingActionButton(
                            heroTag: "verified",
                            onPressed: () async {
                              bool res = await ValidateModel.approveOrNot(
                                  campaignSelectedData['contractAddress'],
                                  campaignSelectedData['ipfsHash'],
                                  true);
                              if (res) {
                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    'Data verified',
                                    style:
                                        CustomTextStyle.spaceMonoWhite(context),
                                  )));
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/home', (Route<dynamic> route) => false);
                                });
                              } else {
                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    'An Error occurred',
                                    style:
                                        CustomTextStyle.spaceMonoWhite(context),
                                  )));
                                });
                              }
                            },
                            backgroundColor: CustomColors.green600(context),
                            child: const Icon(Icons.check)),
                        FloatingActionButton(
                            heroTag: "notVerified",
                            onPressed: () async {
                              bool res = await ValidateModel.approveOrNot(
                                  campaignSelectedData['contractAddress'],
                                  campaignSelectedData['ipfsHash'],
                                  false);
                              if (res) {
                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    'Data verified',
                                    style:
                                        CustomTextStyle.spaceMonoWhite(context),
                                  )));
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/home', (Route<dynamic> route) => false);
                                });
                              } else {
                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    'An Error occurred',
                                    style:
                                        CustomTextStyle.spaceMonoWhite(context),
                                  )));
                                });
                              }
                            },
                            backgroundColor: CustomColors.red600(context),
                            child: const Icon(Icons.close)),
                      ]))
            ]))
        : Center(
            child: Text('Data not available on ipfs.',
                style: CustomTextStyle.spaceMono(context)));
  }
}
