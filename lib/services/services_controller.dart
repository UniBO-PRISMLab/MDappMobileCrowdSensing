import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:mobile_crowd_sensing/services/services.dart';
import '../models/db_capaign_model.dart';
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

  static Future initializeGeofencingService() async {

    DbCampaignModel db = DbCampaignModel();
    List<Campaign> res = await db.campaigns();
    if(res.isNotEmpty) {
      statusGeofencingService = true;
      for(Campaign c in res) {
        FlutterIsolate.spawn(Services.checkGeofence, {
          'address' : c.address,
          'title' : c.title,
          'lat' : c.lat,
          'lng' : c.lng,
          'radius' : c.radius
        });
      }
    }

  }

  static void resetServicies() async {
    FlutterIsolate.killAll();
    statusCloseCampaignService = true;
    statusGeofencingService = true;
    initializeCloseCampaignService();
    initializeGeofencingService();
  }
}