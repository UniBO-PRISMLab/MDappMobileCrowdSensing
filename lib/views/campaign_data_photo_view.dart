import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/controllers/campaign_data_photo_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));

    print("campaign_data_photo_view");


    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
          title: Text(jsonParameters["name"]),
          centerTitle: true,
        ),
        body: const CampaignDataPhotoController());
  }
}
