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
    return FutureBuilder(
      future: AllCampaignModelCampaignModel.getAllCampaign(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(child: Text('Sorry something goes wrong...'));
          case ConnectionState.waiting:
            return CustomSplashScreen.fadingCubeBlueBg(context);
          default:
            return _routingTo(context, snapshot.data,cameFrom);
        }

      }
    );
  }

  Widget _routingTo(BuildContext context,List? result,String cameFrom) {
    if (result != null) {
      if(cameFrom == 'worker') {
        return WorkerCampaignView(contractsAddresses: result[0],);
      } else {
        return VerifierCampaignView(contractsAddresses: result[0],);
      }
    } else {
      return const DialogView(message: 'No Campaigns aviable',);
    }
  }
}
