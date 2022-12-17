import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static blue900(BuildContext context) {
    return Colors.blue[900];
  }
}

class CustomTextStyle {
  static spaceMono(BuildContext context) {
    return GoogleFonts.spaceMono(textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5));
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