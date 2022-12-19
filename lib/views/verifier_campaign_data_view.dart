import 'dart:convert';
import 'package:flutter/material.dart';
import '../controllers/verifier_campaign_data_controller.dart';

class VerifierCampaignDataView extends StatefulWidget {
  const VerifierCampaignDataView({Key? key}) : super(key: key);

  @override
  State<VerifierCampaignDataView> createState() => _VerifierCampaignDataViewState();
}

class _VerifierCampaignDataViewState extends State<VerifierCampaignDataView> {
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
        body: const VerifierCampaignDataController()
    );
  }
}
