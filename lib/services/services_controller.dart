import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:mobile_crowd_sensing/services/geofencing_controller.dart';
import 'package:mobile_crowd_sensing/services/services.dart';

import '../models/session_model.dart';

class ServicesController{

  static bool statusCloseCampaignService = false;
  static bool statusGeofencingService = false;

  static void initializeCloseCampaignService() async {
    FlutterIsolate.spawn(Services.checkCloseCampaign, {
      'accountAddress' : SessionModel().getAccountAddress()
    });
    statusCloseCampaignService = true;
  }

  static void initializeGeofencingService() async {
    FlutterIsolate.spawn(Services.checkGeofence, {});
    statusGeofencingService = true;
  }
}