import 'package:flutter/foundation.dart';
import 'package:mobile_crowd_sensing/models/db_capaign_model.dart';
import 'package:mobile_crowd_sensing/services/geofencing.dart';

class GeofencingController {
  final List<Geofencing> _activeGeofencing = [];

  registerGeofencing(String id, String pointedLatitude,
      String pointedLongitude, String radiusMeter) {
    _activeGeofencing.add(Geofencing(
        id: id,
        pointedLatitude: pointedLatitude,
        pointedLongitude: pointedLongitude,
        radiusMeter: radiusMeter));
    if (kDebugMode) {
      print('\x1B[31m [GEOFENCING CONTROLLER] add Geofence id: $id. \x1B[0m');
    }
  }

   closeAllGeofencing() {
    for (Geofencing g in _activeGeofencing) {
      g.stopGeofenceService();
    }
    _activeGeofencing.clear();

    if (kDebugMode) {
      print('\x1B[31m [GEOFENCING CONTROLLER] delete all geofencing. \x1B[0m');
    }
  }

   getNumberOfActiveGeofence() {
    return _activeGeofencing.length;
  }

   removeGeofenceFromId(String id) {
    Geofencing selected = _activeGeofencing.firstWhere((item) => item.id == id);
    selected.stopGeofenceService();
    _activeGeofencing.remove(selected);
    if (kDebugMode) {
      print('\x1B[31m [GEOFENCING CONTROLLER] delete geofence id: $id \n number of active geofence: ${getNumberOfActiveGeofence()} \x1B[0m');
    }
  }

   getListOfActiveGeofences(){
    return _activeGeofencing;
  }

  List<Stream<GeofenceStatus>> getStreamList() {
    List<Stream<GeofenceStatus>> out = [];
    for(Geofencing g in _activeGeofencing) {
      if(g.getGeofenceStream() != null) {
        out.add(g.getGeofenceStream()!);
      }
    }
    return out;
  }

   Future<void> initializeFromDB() async {
    DbCampaignModel db = DbCampaignModel();
    List res = await db.campaigns();

    for(Campaign c in res) {
      registerGeofencing(
          c.address,
          c.lat,
          c.lng,
          c.radius);
    }
    if (kDebugMode) {
      print('\x1B[31m [GEOFENCING CONTROLLER] initialized: ${res.length} campaigns \x1B[0m');
    }
  }

}
