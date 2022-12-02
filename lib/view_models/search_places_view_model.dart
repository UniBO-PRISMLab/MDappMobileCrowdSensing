import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class SearchPlacesViewModel {
  double lat = 40;
  double lng = 10;
  final double zoom = 19.5;
  late Position position;
  late PlacesDetailsResponse selectedPosition;
  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;

  Future<void> updateLocalPosition() async {
    position = await _getGeoLocationPosition();
    lng = position.longitude;
    lat = position.latitude;
  }

  void updateLocalPositionAndCamera() async {
    await updateLocalPosition();
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), zoom));
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  CameraPosition getCameraPosition() {
    return CameraPosition(target: LatLng(lat, lng), zoom: zoom);
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: FlutterConfig.get('GOOGLE_API_KEY'),
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    selectedPosition = await places.getDetailsByPlaceId(p.placeId!);

    var queryLat = selectedPosition.result.geometry!.location.lat;
    var queryLng = selectedPosition.result.geometry!.location.lng;

    currentState!.setState(() {
      markersList.clear();
      markersList.add(Marker(
          markerId: const MarkerId("0"),
          position: LatLng(queryLat, queryLng),
          infoWindow: InfoWindow(title: selectedPosition.result.name)));
      googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(queryLat, queryLng), zoom));
    });
  }
}
