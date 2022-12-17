import 'package:flutter/cupertino.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class LoginMetamaskModel {

  static Future<void> loginUsingMetamask(BuildContext context) async {
    SessionModel sessionData = SessionModel();
    sessionData.checkConnection();
    if (!sessionData.getConnector().connected) {
      try {
        SessionStatus session = await sessionData.getConnector().createSession(
            onDisplayUri: (uri) async {
              sessionData.setUri(uri);
              await launchUrlString(uri, mode: LaunchMode.externalApplication);
            });
        if(session.accounts.isNotEmpty) {
          sessionData.setSession(session);
        }
      } catch (exp) {
        print(exp);
      }
    }
  }
}