import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum GeofenceStatus { init, enter, exit }

class Geofencing {

  late final String id, pointedLatitude, pointedLongitude, radiusMeter;
  int? eventPeriodInSeconds;

  GeofenceStatus _previusStatus = GeofenceStatus.init;
  GeofenceStatus _status = GeofenceStatus.init;

  bool isStatusChanged = false;

  StreamSubscription<Position>? _positionStream;
  Stream<GeofenceStatus>? _geoFencestream;
  final StreamController<GeofenceStatus> _controller = StreamController<GeofenceStatus>();

  Geofencing({required this.id,required this.pointedLatitude, required this.pointedLongitude, required this.radiusMeter,this.eventPeriodInSeconds}) {

    double latitude = _parser(pointedLatitude);
    double longitude = _parser(pointedLongitude);
    double radiusInMeter = _parser(radiusMeter);

    if (_positionStream == null) {
      _geoFencestream = _controller.stream;
      _positionStream = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high,
      ).listen((Position position) {
        double distanceInMeters = Geolocator.distanceBetween(
            latitude, longitude, position.latitude, position.longitude);
        //_printOnConsole(latitude, longitude, position, distanceInMeters, radiusInMeter);
        _checkGeofence(distanceInMeters, radiusInMeter);
        _positionStream!.pause(Future.delayed(Duration(seconds: (eventPeriodInSeconds != null)? eventPeriodInSeconds! : 2)));
      });
    }
  }

   double _parser(String? value) {
     double doubledValue = 0.0;

     try {
      if(value!.isEmpty) {
        throw Error();
      }
      doubledValue = double.parse(value.isEmpty ? "0" : value);

    } catch (e) {
      print("VALUE IS ===> $value    ${value?.isEmpty}");
      print("EXCEPTION DOUBLE===> $e");
    }
     return doubledValue;
   }

  _checkGeofence(double distanceInMeters, double radiusInMeter) {
    if(_previusStatus == _status) {
      isStatusChanged = false;

      if (distanceInMeters <= radiusInMeter) {
        _status = GeofenceStatus.enter;
      } else {
        _status = GeofenceStatus.exit;
      }

    } else {
      isStatusChanged = true;

      if (distanceInMeters <= radiusInMeter) {
        _status = GeofenceStatus.enter;
      } else {
        _status = GeofenceStatus.exit;
      }

      _previusStatus = _status;
    }

    // if (kDebugMode) {
    //   print("STATUS GEOFENCE: $_status  IS CHANGED: $isStatusChanged");
    // }
  }

  GeofenceStatus getStatus() {
    return _status;
  }

  stopGeofenceService() {
    if (_positionStream != null) {
      _positionStream!.cancel();
    }
  }

  Stream<GeofenceStatus>? getGeofenceStream() {
    return _geoFencestream;
  }

  // _printOnConsole(
  //     latitude, longitude, Position position, distanceInMeters, radiusInMeter) {
  //   print("Started Position $latitude  $longitude");
  //   print("Current Position ${position.toJson()}");
  //   print(
  //       "Distance in meters $distanceInMeters and Radius in Meter $radiusInMeter");
  // }
}
