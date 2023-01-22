import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobile_crowd_sensing/models/geofence_model.dart';
import '../models/db_capaign_model.dart';
import '../utils/geofence_status.dart';

class GeofenceController {

  static List<GeofenceModel> geofenceList = [];
  static final DbCampaignModel db = DbCampaignModel();
  static int geofenceActive = 0;
  static final GeofenceController _instance = GeofenceController._internal();
  static List<StreamSubscription<GeofenceStatus>?> geofenceStatusStream = [];

  //This singleton class allows to store all
  //GeofeceModel in order to manage them and
  //streams the result and interact with campaignsDB

  factory GeofenceController() {
    return _instance;
  }

  GeofenceController._internal();

  static geofenceInitByDb() async {
    List<Campaign> campaigns = await db.campaigns();
    for(Campaign c in campaigns) {

      GeofenceModel g = GeofenceModel(
          pointedLatitude: c.lat,
          pointedLongitude: c.lng,
          radiusMeter: c.radius,
      );
      geofenceList.add(g);
      g.startGeofenceService();
      geofenceActive++;
    }

    if (kDebugMode) {
      print("\n Active Geofences: $geofenceActive \n");
    }
  }

  static geofenceUpdateByDb() async {
    for(GeofenceModel g in geofenceList) {
      g.stopGeofenceService();
      geofenceList.remove(g);
    }
    geofenceActive = 0;
    geofenceInitByDb();
  }

}