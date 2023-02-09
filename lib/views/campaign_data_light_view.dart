import 'dart:convert';
import 'package:flutter/material.dart';
import '../controllers/campaign_data_light_controller.dart';
import '../models/file_manager_model.dart';
import '../utils/worker_campaign_data_factory.dart';
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
  @override
  initState() {
    super.initState();
    FileManagerModel.clearTemporaryDirectory();
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
          centerTitle: true,
          title: Text(campaignSelectedData['name']),
        ),
        body: const CampaignDataLightController());
  }
}

