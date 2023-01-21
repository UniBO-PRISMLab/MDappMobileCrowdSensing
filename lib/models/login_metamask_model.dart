import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'backgorund_service_model.dart';

class LoginMetamaskModel {

  static Future<void> loginUsingMetamask(BuildContext context) async {
    SessionModel sessionData = SessionModel();
    sessionData.checkConnection();
    if (!sessionData.connector.connected) {
      try {
        SessionStatus session = await sessionData.connector.createSession(
            onDisplayUri: (uri) async {
              sessionData.uri = uri;
              await launchUrlString(uri, mode: LaunchMode.externalApplication);
            });
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('address', sessionData.getAccountAddress());
        print('\x1B[31m[Filled shared preferences]\x1B[0m');
        print('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n'
            '+ sessionData indirizzo account:  ${sessionData.getAccountAddress()}  +\n'
            '+ Connector è connesso?: ${sessionData.connector.connected}  +\n'
            '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
        await initializeService();
      } catch (exp) {
        print(exp);
      }
    } else {
      print("già connesso...");
    }
  }
}