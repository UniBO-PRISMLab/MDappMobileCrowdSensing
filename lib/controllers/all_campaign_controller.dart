import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';
import '../models/all_campaign_model.dart';
import '../views/dialog_view.dart';
import '../views/verifier_campaign_view.dart';
import '../views/worker_campaign_view.dart';

class AllCampaignController extends StatelessWidget {
  final String cameFrom;
  const AllCampaignController({required this.cameFrom,super.key});

  @override
  Widget build(BuildContext context) {
    AllCampaignModelCampaignModel.getAllCampaign(context,cameFrom);
    return CustomSplashScreen.fadingCubeBlueBg(context);
  }

  static routingTo(BuildContext context,List? result,String cameFrom) {
    if (result != null) {
      if(cameFrom == 'worker') {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>
                WorkerCampaignView(contractsAddresses: result[0],)));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>
                VerifierCampaignView(contractsAddresses: result[0],)));
      }
    } else {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const DialogView(message: 'No Campaigns aviable',)));
    }
  }
}
