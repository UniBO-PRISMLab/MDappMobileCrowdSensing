import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_crowd_sensing/models/db_capaign_model.dart';
import 'package:mobile_crowd_sensing/models/search_places_model.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/services/services_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginMetamaskModel {

  static Future<void> loginUsingMetamask(BuildContext context) async {
    SessionModel sessionData = SessionModel();
    sessionData.checkConnection();
    if (!sessionData.connector.connected) {
      try {
        await sessionData.connector.createSession(
            onDisplayUri: (uri) async {
              sessionData.uri = uri;
              await launchUrlString(uri, mode: LaunchMode.externalApplication);
            });
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('address', sessionData.getAccountAddress());
        if (kDebugMode) {
          print('\x1B[31m[Filled shared preferences]\x1B[0m');
          print('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n'
              '+ sessionData indirizzo account:  ${sessionData.getAccountAddress()}  +\n'
              '+ Connector è connesso?: ${sessionData.connector.connected}  +\n'
              '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
        }

        if(!ServicesController.statusGeofencingService) {
          print('\x1B[31m [GEOFENCE SERVICE] INITIALIZE AFTER LOGIN\x1B[0m');
          SearchPlacesModel search = SearchPlacesModel();
          await search.getPermissions();
          ServicesController.initializeGeofencingService();
        }

        if(!ServicesController.statusCloseCampaignService) {
          print('\x1B[31m [CLOSED CAMPAIGN SERVICE] INITIALIZE AFTER LOGIN\x1B[0m');
          ServicesController.initializeCloseCampaignService();
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