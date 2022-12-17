import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/sourcer_past_campaigns_model.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';
import '../views/dialog_view.dart';
import '../views/sourcer_closed_campaign_view.dart';

class SourcerPastCampaignsController extends StatefulWidget {

  const SourcerPastCampaignsController({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SourcerPastCampaignsControllerState createState() => _SourcerPastCampaignsControllerState();
}

class _SourcerPastCampaignsControllerState extends State<SourcerPastCampaignsController> {

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen.fadingCubeBlueBg(context);
  }

  _getData() async {
    await SourcerPastCampaignsModel.getMyClosedCampaign(context).then((value) => {
      _goTo(value)
    });
  }

  _goTo(result){
    if (result.isNotEmpty && result != null) {
      setState(() {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SourcerClosedCampaignView(contractAddress: result,)));
      });
    } else {
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const DialogView(goTo: "sourcer", message: 'No Campaigns Aviable')));
      });
    }
  }
}














