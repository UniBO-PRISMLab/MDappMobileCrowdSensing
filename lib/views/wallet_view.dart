import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

import '../controllers/claim_campaign_controller.dart';
import '../controllers/wallet_controller.dart';
import 'login_view.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SessionModel session = SessionModel();
    if(!session.provider.connector.connected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
      });}

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
