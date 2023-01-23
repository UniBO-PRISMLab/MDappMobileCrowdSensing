import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/services/geofencing_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/closed_campaign_service.dart';

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
        if(!ClosedCampaignService().checkIfInitialized()) {
          print('\x1B[31m[INITIALIZE AFTER LOGIN]\x1B[0m');
          await ClosedCampaignService().initializeClosedCampaignService();
        }
        //await initializeGeofencingService();
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