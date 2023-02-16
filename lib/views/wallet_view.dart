import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (!session.provider.connector.connected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginView()));
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Flexible(flex: 2, child: Container()),
            const Flexible(flex: 1, child: Text("HOME")),
            Flexible(flex: 1, child: Container()),
            Flexible(
                flex: 1,
                child: TextButton(
                    onPressed: () async {
                      await SessionModel().disconnect();
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                      });
                    },
                    child: const Text(
                      "LOGOUT",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    )))
          ]),
          centerTitle: true,
          backgroundColor: CustomColors.blue900(context),
        ),
        body: Column(
            children: const [WalletController(), ClaimCampaignController()]));
  }
}
