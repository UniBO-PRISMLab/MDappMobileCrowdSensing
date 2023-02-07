import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../services/services_controllerV2.dart';
import 'db_session_model.dart';

class LoginMetamaskModel {

  static Future<void> loginUsingMetamask(BuildContext context) async {
    SessionModel sessionData = SessionModel();

    if (!sessionData.connector.connected) {
      try {
        SessionStatus newSession = await sessionData.connector.createSession(
            onDisplayUri: (uri) async {
              sessionData.uri = uri;
              await launchUrlString(uri, mode: LaunchMode.externalApplication);

            });

        DbSessionModel sessionDb = DbSessionModel();
        await sessionDb.deleteAll();
        await sessionDb.insertSession(Session(account: newSession.accounts[0], chainId: newSession.chainId));
        
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('address', sessionData.getAccountAddress());
        if (kDebugMode) {
          print('\x1B[31m[Filled shared preferences]\x1B[0m');
          print('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n'
              '+ sessionData indirizzo account:  ${sessionData.getAccountAddress()}  +\n'
              '+ Connector è connesso?: ${sessionData.connector.connected}  +\n'
              '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
        }

/*        if(!ServicesControllerV2.statusGeofencingService) {
          print('\x1B[31m [GEOFENCE SERVICE] INITIALIZE AFTER LOGIN\x1B[0m');
          SearchPlacesModel search = SearchPlacesModel();
          await search.getPermissions();
          ServicesControllerV2.initializeGeofencingService();
        }*/

        if(!ServicesControllerV2.statusCloseCampaignService) {
          print('\x1B[31m [CLOSED CAMPAIGN SERVICE] INITIALIZE AFTER LOGIN\x1B[0m');
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