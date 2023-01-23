import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../services/geofence_status.dart';

class GeofenceModel {

  late String pointedLatitude, pointedLongitude, radiusMeter;
  late int? eventPeriodInSeconds;


  //documentation: istantiate a Geofance object
  //
  // if not set eventPeriodInSeconds it will be automatically set to 10 sec

  GeofenceModel(
      {
        required this.pointedLatitude,
        required this.pointedLongitude,
        required this.radiusMeter,
        this.eventPeriodInSeconds
      });

  StreamSubscription<Position>? _positionStream;

  Stream<GeofenceStatus>? _geoFencestream;

  final StreamController<GeofenceStatus> _controller = StreamController<GeofenceStatus>();

  double _parser(String value) {
    if (kDebugMode) {
      print("Parse value===>${value.isEmpty}");
    }
    double? doubledValue = 0.0;
    try {
      doubledValue = double.parse(value.isEmpty ? "0" : value);
    } catch (e) {
      if (kDebugMode) {
        print("VALUE IS ===> $value    ${value.isEmpty}");
        print("EXCEPTION DOUBLE===> $e");
      }
    }
    return doubledValue!;
  }

  Stream<GeofenceStatus>? getGeofenceStream() {
    return _geoFencestream;
  }

   startGeofenceService() {
    //parsing the values to double if in any case they are coming in int etc
    double latitude = _parser(pointedLatitude);
    double longitude = _parser(pointedLongitude);
    double radiusInMeter = _parser(radiusMeter);
    //starting the geofence service only if the positionstream is null with us
    if (_positionStream == null) {
      _geoFencestream = _controller.stream;
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy:LocationAccuracy.high),
      ).listen((Position position) {
        double distanceInMeters = Geolocator.distanceBetween(
            latitude, longitude, position.latitude, position.longitude);
        _printOnConsole(
            latitude, longitude, position, distanceInMeters, radiusInMeter);
        _checkGeofence(distanceInMeters, radiusInMeter);
        _positionStream!
            .pause(Future.delayed(Duration(seconds: (eventPeriodInSeconds == null)? 10 : eventPeriodInSeconds!)));
      });
      _controller.add(GeofenceStatus.init);
    }
  }

   _checkGeofence(double distanceInMeters, double radiusInMeter) {
    if (distanceInMeters <= radiusInMeter) {
      _controller.add(GeofenceStatus.enter);
    } else {
      _controller.add(GeofenceStatus.exit);
    }
  }

   stopGeofenceService() {
    if (_positionStream != null) {
      _positionStream!.cancel();
    }
  }

   _printOnConsole(
      latitude, longitude, Position position, distanceInMeters, radiusInMeter) {
    if (kDebugMode) {
      print("Started Position $latitude  $longitude");
      print("Current Position ${position.toJson()}");
      print("Distance in meters $distanceInMeters and Radius in Meter $radiusInMeter");
    }
  }
}
