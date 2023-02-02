import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

import '../controllers/claim_campaign_controller.dart';
import '../controllers/wallet_controller.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("HOME"),
          centerTitle: true,
          backgroundColor: CustomColors.blue900(context),
        ),
      body: Column( children: const [
        WalletController(),
        ClaimCampaignController()
      ])
    );
  }
}
