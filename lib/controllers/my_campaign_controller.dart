import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/my_campaign_model.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';
import '../views/dialog_view.dart';
import '../views/sourcer_campaign_view.dart';

class MyCampaignController extends StatefulWidget {
  const MyCampaignController({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyCampaignControllerState createState() => _MyCampaignControllerState();
}

class _MyCampaignControllerState extends State<MyCampaignController> {

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
    await MyCampaignModel.getMyCampaign(context).then((value) => {
      _goTo(value)
    });
  }

  _goTo(result) {
    if (result != null) {
      setState(() {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SourcerCampaignView(contractAddress: result,)));
      });
    } else {
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const DialogView(goTo: "sourcer", message: 'No Campaign Aviable')));
      });
    }
  }


}














