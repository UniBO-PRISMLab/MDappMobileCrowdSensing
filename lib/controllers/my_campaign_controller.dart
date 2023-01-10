import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/my_campaign_model.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';
import '../views/dialog_view.dart';

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
    List result = [];
    String? address = (await MyCampaignModel.getMyCampaign())?[0].toString();
    if(address!=null) {
      List? data = await MyCampaignModel.getCampaignData(address);
      if(data != null) {
        result = data;
        result.add(address);
        _goTo(result);
      } else {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const DialogView(message: "No Campaign available")));
        });
      }
    } else {
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const DialogView(message: "Error. can't retrieve data for the current campaign.")));
      });
    }
  }

  _goTo(List result) {
      setState(() {
        Navigator.pushReplacementNamed(context,'/current_campaign',arguments: {
          'name': result.first,
          'lat': result[1].toString(),
          'lng': result[2].toString(),
          'range': result[3].toString(),
          'campaignType': result[4].toString(),
          'addressCrowdSourcer': result[5].toString(),
          'fileCount': result[6].toString(),
          'redebleLocation': result[7].toString(),
          'contractAddress': result.last.toString(),
        });
      });
  }


}














