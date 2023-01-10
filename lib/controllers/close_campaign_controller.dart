import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';
import '../views/dialog_view.dart';
import '../models/close_campaign_model.dart';

class CloseCampaignController extends StatelessWidget {
  final String address;
  const CloseCampaignController({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    CloseCampaignModel.closeMyCampaign(context,address);
    return CustomSplashScreen.fadingCubeBlueBg(context);
  }

  static routing(BuildContext context,List? result) {
    if (result != null) {
      Navigator.pushReplacementNamed(context, '/sourcer');
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DialogView(message: "An error occurred. Campaign still open")));
    }
  }

}
