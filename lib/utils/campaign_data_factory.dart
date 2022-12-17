import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../views/campaigns/campaign_data_light_view.dart';
import '../views/campaigns/photo_join_campaign_view.dart';
import '../views/campaigns/light_join_campaign_view.dart';

abstract class DataCampaignFactory extends StatefulWidget{
  const DataCampaignFactory({super.key});

  factory DataCampaignFactory.fromTypeName(BuildContext context) {
    String typeName = jsonDecode(jsonEncode(ModalRoute.of(context)!.settings.arguments))['type'];

    if (typeName == 'light') return const CampaignDataLightView();
    //... maybe future implementations
    throw "$typeName Campaign Type not recognized.";
  }

}


