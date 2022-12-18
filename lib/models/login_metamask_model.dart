import 'package:flutter/cupertino.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

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

        if(session.accounts.isNotEmpty) {
          sessionData.session = session;
          print("connesso!");
        }
      } catch (exp) {
        print(exp);
      }
    } else {
      print("già connesso...");
    }
  }
}