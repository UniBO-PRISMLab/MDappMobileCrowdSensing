import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';
import '../models/create_campaign_model.dart';

class CreateCampaignController extends StatelessWidget {
  final dynamic name,lat,lng,range,type,value;
  const CreateCampaignController({required this.name,required this.lat,required this.lng,required this.range,required this.type,required this.value,super.key});

  @override
  Widget build(BuildContext context) {
    CreateCampaignModel.createCampaign(context, name,BigInt.from(lat),BigInt.from(lng),BigInt.from(range), type,BigInt.from(value));
    return CustomSplashScreen.fadingCubeBlueBg(context);
  }

  static routingTo(BuildContext context,value) {
    if (value!=null && value!='0x0000000000000000000000000000000000000000') {
      Navigator.popAndPushNamed(context, '/sourcer');
    }
  }
}
