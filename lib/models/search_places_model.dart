import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class SearchPlacesModel {
  double lat = 40;
  double lng = 10;
  String address = "";
  late Position position;
  var client = http.Client();
  bool serviceEnabled = false;
  late LocationPermission permission;

  Future<void> updateLocalPosition() async {
    await Future.delayed(const Duration(seconds: 1));
    position = await _getGeoLocationPosition();
    lng = position.longitude;
    lat = position.latitude;
    address = await getReadebleLocationFromLatLng(lat,lng);
    if (kDebugMode) {
      print("\n[DEVICE POSITION]: \n[lat]$lat\n[lng]$lng\n");
    }
  }

  Future<bool?> getPermissions() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  Future<Position> _getGeoLocationPosition() async {
    getPermissions();
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future<String> getReadebleLocationFromLatLng(double latitude, double longitude) async {
    try {
        if (kDebugMode) {
          print(latitude);
        }
        if (kDebugMode) {
          print(longitude);
        }
        String url =
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

        var response = await client.post(Uri.parse(url));
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
        return decodedResponse['display_name'];
    }catch (e){
      if (kDebugMode) {
        print("[ERROR]: $e");
      }
      return 'Error';
    }
  }

}
