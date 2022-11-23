import 'dart:convert';
import 'package:flutter/material.dart';

import '../../utils/join_campaign_factory.dart';

class TemperatureJoinCampaignView extends JoinCampaignFactory {
  const TemperatureJoinCampaignView({super.key});

  @override
  TemperatureJoinCampaignViewState createState() {
    return TemperatureJoinCampaignViewState();
  }
}

class TemperatureJoinCampaignViewState extends State<TemperatureJoinCampaignView> {

  dynamic positionSelectedData = {};
  Object? parameters;


  @override
  Widget build(BuildContext context) {

    parameters = ModalRoute.of(context)!.settings.arguments;
    positionSelectedData = jsonDecode(jsonEncode(parameters));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Go to catch some Temperatures'),
        ),
        body: TextButton(onPressed: () {  }, child: const Text('SEND DATA'),),
    );
  }
}
