import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../services/services_controllerV2.dart';
import 'db_session_model.dart';

class LoginMetamaskModel {

  static Future<void> loginUsingMetamask(BuildContext context) async {
    SessionModel sessionData = SessionModel();

    if (!sessionData.connector.connected) {
      DbSessionModel sessionDb = DbSessionModel();
      try {
        SessionStatus newSession = await sessionData.connector.createSession(
            onDisplayUri: (uri) async {
              if (kDebugMode) {
                print('\x1B[31m[LOGIN METAMASK] uri: $uri\x1B[0m');
              }
              sessionData.uri = uri;
              await launchUrlString(uri, mode: LaunchMode.externalApplication);

            });

        if (kDebugMode) {
          print('\x1B[31m\n[SESSION CREATION]\n'
              '\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n'
              '\n[SESSION DATA]\n'
              '+ sessionData indirizzo accounts:  ${sessionData.getAccountAddress()}  +\n'
              '\n[CONNECTOR]\n'
              '+ Connector è connesso?: ${sessionData.connector.connected}  +\n'
              '\n[NEW SESSION]\n'
              'accounts: ${newSession.accounts.toString()}'
              '\n[SESSION STORAGE]\n'
              'accounts: ${(await sessionData.sessionStorage.getSession())?.accounts.length}\n'
              '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\x1B[0m');
        }

        await sessionDb.deleteAll();
        await sessionDb.insertSession(Session(account: newSession.accounts[0], chainId: newSession.chainId, uri: sessionData.uri));

        if(!ServicesControllerV2.statusCloseCampaignService) {
          if (kDebugMode) {
            print('\x1B[31m [CLOSED CAMPAIGN SERVICE] INITIALIZE AFTER LOGIN\x1B[0m');
          }
          ServicesControllerV2.initializeCloseCampaignService();
        }

      } catch (exp) {
        if (kDebugMode) {
          print(exp);
        }
      }
    } else {
      if (kDebugMode) {
        print("già connesso...");
      }
    }
  }
}