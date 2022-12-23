import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../views/photo_join_campaign_view.dart';
import '../views/light_join_campaign_view.dart';

abstract class JoinCampaignFactory extends StatefulWidget{
  const JoinCampaignFactory({super.key});

  factory JoinCampaignFactory.fromTypeName(BuildContext context) {
    String typeName = jsonDecode(jsonEncode(ModalRoute.of(context)!.settings.arguments))['type'];

    if (typeName == 'photo') return const PhotoJoinCampaignView();
    if (typeName == 'light') return const LightJoinCampaignView();
    //... maybe future implementations
    throw "$typeName Campaign Type not recognized.";
  }

}


