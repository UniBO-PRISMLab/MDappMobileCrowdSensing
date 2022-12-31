import 'package:flutter/material.dart';
import '../controllers/sourcer_campaign_controller.dart';
import '../utils/styles.dart';

class SourcerCampaignView extends StatelessWidget {
  const SourcerCampaignView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
          title: const Text('Your Campaign'),
          centerTitle: true,
        ),
        body: const SourcerCampaignController());
  }
}
