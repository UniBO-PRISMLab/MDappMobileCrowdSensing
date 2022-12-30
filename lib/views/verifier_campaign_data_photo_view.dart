import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import 'package:mobile_crowd_sensing/utils/verifier_campaign_data_factory.dart';
import '../controllers/verifier_campaign_data_photo_controller.dart';

class VerifierCampaignDataPhotoView extends VerifierDataCampaignFactory {
  const VerifierCampaignDataPhotoView({Key? key}) : super(key: key);

  @override
  State<VerifierCampaignDataPhotoView> createState() => _VerifierCampaignDataPhotoViewState();
}

class _VerifierCampaignDataPhotoViewState extends State<VerifierCampaignDataPhotoView> {
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
          title: Text(jsonParameters["name"]),
          centerTitle: true,
        ),
        body: const VerifierCampaignDataPhotoController()
    );
  }
}
