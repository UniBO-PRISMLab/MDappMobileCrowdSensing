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

  bool downloadGate = false;
  late String? hash;
  late List<File> pictures = [];

  _prepareData() async {
    Stream<FileSystemEntity>? res = await ValidateModel.downloadPhotosFiles(hash);
    if (res != null) {
      res.forEach((element) {
        pictures.add(File(element.path));
      });
      downloadGate = !downloadGate;
      if (kDebugMode) {
        print("PREPARING DATA: ${pictures.length}");
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    hash = campaignSelectedData['ipfsHash'];
    if (hash != null && !downloadGate) {
      _prepareData();
    }
    return (pictures.isNotEmpty)
        ? ListView(shrinkWrap: false, children: [
            Column(
              children: [
                Text(
                  'ipfs hash: ',
                  style: CustomTextStyle.spaceMonoBold(context),
                ),
                Text(
                  '${campaignSelectedData['ipfsHash']}',
                  style: CustomTextStyle.inconsolata(context),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: DeviceDimension.deviceHeight(context) * 0.15,
                  left: DeviceDimension.deviceWidth(context) * 0.09,
                ),
                child: Wrap(
                    alignment: WrapAlignment.spaceAround, // set your alignment
                    children: [
                      Row(children: [
                        Text('Number of relevations: ',
                            style: CustomTextStyle.merriweatherBold(context)),
                        Text('${pictures.length}',
                            style: CustomTextStyle.inconsolata(context))
                      ]),
                      Center(
                        child: SizedBox(
                          height: 200, // card height
                          child: PageView.builder(
                              itemCount: pictures.length,
                              controller: PageController(viewportFraction: 0.7),
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
                                hash,
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
                                Navigator.pushReplacementNamed(
                                    context, '/home');
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
                                hash,
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
                                Navigator.pushReplacementNamed(
                                    context, '/home');
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
          ])
        : Center(child: Text('Data not available on ipfs.',style: CustomTextStyle.spaceMono(context)));
  }
}
