import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../views/campaigns/photo_join_campaign_view.dart';
import '../views/campaigns/temperature_join_campaign_view.dart';

abstract class JoinCampaignFactory extends StatefulWidget{
  const JoinCampaignFactory({super.key});

  factory JoinCampaignFactory.fromTypeName(BuildContext context) {
    String typeName = jsonDecode(jsonEncode(ModalRoute.of(context)!.settings.arguments))['campaignType'].toLowerCase();

    if (typeName == 'photo') return const PhotoJoinCampaignView();
    if (typeName == 'temperature') return const TemperatureJoinCampaignView();
    //... maybe future implementations
    throw "$typeName Campaign Type not recognized.";
  }

}


