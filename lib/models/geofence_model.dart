import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_crowd_sensing/services/notification_channels.dart';
import '../controllers/distance_controller.dart';
import 'dart:async';
import 'dart:ui';

enum GeofenceEvent { init, enter, exit }

class Geofence {
  late String title, address, lat, lng, radius;

  StreamSubscription<Position>? _positionStream;
  Stream<GeofenceEvent>? _geostream;
  final StreamController<GeofenceEvent> _controller =
      StreamController<GeofenceEvent>();

  Geofence(this.title, this.address, this.lat, this.lng, this.radius);

  Future<void> initialize() async {
    DartPluginRegistrant.ensureInitialized();

    String debugString = "[GEOFENCE $title]";

    final FlutterLocalNotificationsPlugin notification =
        FlutterLocalNotificationsPlugin();

    if (kDebugMode) {
      print('\x1B[31m [GEOFENCE SERVICE] geofence open for:'
          '\n $title'
          '\n $address'
          '\n $lat '
          '\n $lng '
          '\n $radius \x1B[0m');
    }

    await _startGeofenceService(
        pointedLatitude: lat,
        pointedLongitude: lng,
        radiusMeter: radius, // TO CHANGE
        eventPeriodInSeconds: 10);

    GeofenceEvent? previous;

    getGeofenceStream()?.listen((GeofenceEvent event) {
      if (kDebugMode) {
        print(event.toString());
      }

      if (previous == null || previous == GeofenceEvent.init) {
        switch (event) {
          case GeofenceEvent.enter:
            previous = event;
            break;
          case GeofenceEvent.exit:
            previous = event;
            break;
          default:
            previous = event;
            break;
        }
      }

      switch (event) {
        case GeofenceEvent.init:
          if (kDebugMode) {
            print('\x1B[31m $debugString status: Init\x1B[0m');
          }
          previous = event;
          break;
        case GeofenceEvent.enter:
          if (kDebugMode) {
            print('\x1B[31m $debugString status: Enter\x1B[0m');
          }
          if (previous != event) {
            notification.show(
              888,
              'Entered in Campaign Area',
              '[$title] \nat address: $address',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  NotificationChannel.backgroundServiceChannel.id,
                  NotificationChannel.backgroundServiceChannel.name,
                  icon: 'ic_bg_service_small',
                  styleInformation: BigTextStyleInformation(
                      "<p>You are entered inside the \"$title\" \n campaign at address: \n$address</p>",
                      htmlFormatBigText: true,
                      contentTitle: "<h1>ENTER INSIDE \"$title\"</h1>",
                      htmlFormatContentTitle: true,
                      summaryText: "<p>you entered in a campaign area</p>",
                      htmlFormatSummaryText: true,
                      htmlFormatContent: true,
                      htmlFormatTitle: true),
                  ongoing: true,
                ),
              ),
            );
          } else {
            if (kDebugMode) {
              print('\x1B[31m $debugString status not changed \x1B[0m');
            }
          }
          previous = event;
          break;
        case GeofenceEvent.exit:
          if (kDebugMode) {
            print('\x1B[31m $debugString status: Exit\x1B[0m');
          }
          if (previous != event) {
            notification.show(
                888,
                'Exit from Campaign Area',
                '[$title] \nat address: $address',
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    NotificationChannel.backgroundServiceChannel.id,
                    NotificationChannel.backgroundServiceChannel.name,
                    icon: 'ic_bg_service_small',
                    styleInformation: BigTextStyleInformation(
                        "<p>You are out of the \"$title\" \n campaign at address: \n$address</p>",
                        htmlFormatBigText: true,
                        contentTitle: "<h1>EXIT FROM \"$title\"</h1>",
                        htmlFormatContentTitle: true,
                        summaryText: "<p>you exit from a campaign area</p>",
                        htmlFormatSummaryText: true,
                        htmlFormatContent: true,
                        htmlFormatTitle: true),
                    ongoing: true,
                  ),
                ));
          } else {
            if (kDebugMode) {
              print('\x1B[31m $debugString status not changed \x1B[0m');
            }
          }
          previous = event;
          break;
      }
    });
  }

  _startGeofenceService(
      {required String pointedLatitude,
      required String pointedLongitude,
      required String radiusMeter,
      required int eventPeriodInSeconds}) async {
    double latitude = _parser(pointedLatitude);
    double longitude = _parser(pointedLongitude);
    double radiusInMeter = _parser(radiusMeter);
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;
    if (_positionStream == null) {
      _geostream = _controller.stream;
      _positionStream = Geolocator.getPositionStream(
              locationSettings:
                  const LocationSettings(accuracy: LocationAccuracy.best))
          .listen((Position? position) {
        if (position != null) {
          double distanceInMeters = DistanceController.distanceBetween(
              latitude, longitude, position.latitude, position.longitude);
          _checkGeofence(distanceInMeters, radiusInMeter);
          _positionStream!
              .pause(Future.delayed(Duration(seconds: eventPeriodInSeconds)));
        }
      });
      _controller.add(GeofenceEvent.init);
    }
  }

  double _parser(String value) {
    return double.parse(value);
  }

  Stream<GeofenceEvent>? getGeofenceStream() {
    return _geostream;
  }

  _checkGeofence(double distanceInMeters, double radiusInMeter) {
    if (distanceInMeters <= radiusInMeter) {
      _controller.add(GeofenceEvent.enter);
    } else {
      _controller.add(GeofenceEvent.exit);
    }
  }

  stopGeofenceService() {
    if (_positionStream != null) {
      _positionStream!.cancel();
    }
  }
}
