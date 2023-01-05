import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

import '../controllers/wallet_controller.dart';

class WalletView extends StatelessWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        AppBar(
            centerTitle: true,
            title: Text('Wallet',style:CustomTextStyle.spaceMonoWhite(context)),
            backgroundColor: CustomColors.blue900(context),
        ),
      body: Column(
        children: const [
          WalletController()
        ]
      )
    );
  }
}
