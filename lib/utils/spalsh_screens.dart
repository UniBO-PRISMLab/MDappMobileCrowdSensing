import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

class CustomSplashScreen {
  static fadingCubeBlueBg(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.blue900(context),
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.white,
              size: 50.0,
            )
        )
    );
  }
}
