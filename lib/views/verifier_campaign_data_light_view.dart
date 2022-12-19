import 'dart:convert';
import 'package:flutter/material.dart';
import '../controllers/verifier_campaign_data_light_controller.dart';

class VerifierCampaignDataLightView extends StatefulWidget {
  const VerifierCampaignDataLightView({Key? key}) : super(key: key);

  @override
  State<VerifierCampaignDataLightView> createState() => _VerifierCampaignDataLightViewState();
}

class _VerifierCampaignDataLightViewState extends State<VerifierCampaignDataLightView> {
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
          backgroundColor: Colors.blue[900],
          title: Text(jsonParameters["name"]),
          centerTitle: true,
        ),
        body: const VerifierCampaignDataLightController()
    );
  }
}
