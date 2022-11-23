import 'dart:convert';
import 'package:flutter/material.dart';

import '../../utils/join_campaign_factory.dart';

class PhotoJoinCampaignView extends JoinCampaignFactory {
  const PhotoJoinCampaignView({super.key});

  @override
  TemperatureJoinCampaignViewState createState() {
    return TemperatureJoinCampaignViewState();
  }
}

class TemperatureJoinCampaignViewState extends State<PhotoJoinCampaignView> {

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
        title: const Text('Go to catch some Photos'),
      ),
      body: TextButton(onPressed: () {  }, child: const Text('SEND DATA'),),
    );
  }
}
