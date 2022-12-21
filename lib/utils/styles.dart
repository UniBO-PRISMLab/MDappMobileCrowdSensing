import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceDimension {
  static double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
}

class CustomColors {
  static blue900(BuildContext context) {
    return Colors.blue[900];
  }

  static green600(BuildContext context) {
    return Colors.green[600];
  }

  static red600(BuildContext context) {
    return Colors.red[600];
  }

  static blue600(BuildContext context) {
    return Colors.blue[600];
  }

  static customWhite(BuildContext context) {
    return Colors.white54;
  }
}

class CustomTextStyle {
  static spaceMono(BuildContext context) {
    return GoogleFonts.spaceMono(textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5));
  }

  static spaceMonoWhite(BuildContext context) {
    return GoogleFonts.spaceMono(textStyle: const TextStyle(color: Colors.white, letterSpacing: .5));
  }

  static spaceMonoBold(BuildContext context) {
    return GoogleFonts.spaceMono(textStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: .5));
  }

  static spaceMonoH40Bold(BuildContext context) {
    return GoogleFonts.spaceMono(textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5, fontSize: 40, fontWeight: FontWeight.bold));
  }

  static merriweatherBold(BuildContext context) {
   return GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 16);
  }

  static inconsolata(BuildContext context) {
    return GoogleFonts.inconsolata(fontSize: 16);
  }
}

class GlobalText {
  static loadingText(BuildContext context) {
    return Text('LOADING...', style: CustomTextStyle.spaceMono(context),);
  }

}