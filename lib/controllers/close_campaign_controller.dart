import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';
import '../views/dialog_view.dart';
import '../models/close_campaign_model.dart';

class CloseCampaignController extends StatefulWidget {
  const CloseCampaignController({super.key});

  @override
  State<CloseCampaignController> createState() =>
      _CloseCampaignControllerState();
}

class _CloseCampaignControllerState extends State<CloseCampaignController> {
  @override
  Widget build(BuildContext context) {
    _getData(context);
    return CustomSplashScreen.fadingCubeBlueBg(context);
  }

  Future<void> _getData(BuildContext context) async {
    String result = await CloseCampaignModel.closeMyCampaign(context);

    if (result.contains("Campaign Closed")) {
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DialogView(
                  message: "Error on result:\n${result.toString()}")));
    }
  }
}
