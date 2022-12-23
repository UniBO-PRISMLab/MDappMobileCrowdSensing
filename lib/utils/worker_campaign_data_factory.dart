import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../views/campaign_data_photo_view.dart';
import '../views/campaign_data_light_view.dart';

abstract class WorkerDataCampaignFactory extends StatefulWidget{
  const WorkerDataCampaignFactory({super.key});

  factory WorkerDataCampaignFactory.fromTypeName(BuildContext context) {
    String typeName = jsonDecode(jsonEncode(ModalRoute.of(context)!.settings.arguments))['type'];
    if (typeName == 'photo') return const CampaignDataPhotoView();
    if (typeName == 'light') return const CampaignDataLightView();
    //... maybe future implementations
    throw "$typeName Campaign Type not recognized.";
  }

}


