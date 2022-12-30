import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/verifier_campaign_data_factory.dart';
import '../controllers/validate_photo_controller.dart';

class ValidatePhotoView extends VerifierDataCampaignFactory {
  const ValidatePhotoView({Key? key}) : super(key: key);

  @override
  State<ValidatePhotoView> createState() => _VerifierCampaignDataLightViewState();
}

class _VerifierCampaignDataLightViewState extends State<ValidatePhotoView> {
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
          backgroundColor: Colors.red[900],
          title: Text(jsonParameters["name"]),
          centerTitle: true,
        ),
        body: const ValidatePhotoController()
    );
  }
}
