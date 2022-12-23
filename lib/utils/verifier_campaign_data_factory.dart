import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../views/verifier_campaign_data_light_view.dart';
import '../views/verifier_campaign_data_photo_view.dart';


abstract class VerifierDataCampaignFactory extends StatefulWidget{
  const VerifierDataCampaignFactory({super.key});

  factory VerifierDataCampaignFactory.fromTypeName(BuildContext context) {
    String typeName = jsonDecode(jsonEncode(ModalRoute.of(context)!.settings.arguments))['type'];
    if (typeName == 'photo') return const VerifierCampaignDataPhotoView();
    if (typeName == 'light') return const VerifierCampaignDataLightView();
    //... maybe future implementations
    throw "$typeName Campaign Type not recognized.";
  }

}


