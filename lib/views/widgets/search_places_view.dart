import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_crowd_sensing/views/dialog_view.dart';
import '../../view_models/search_places_view_model.dart';
import 'package:google_maps_webservice/places.dart';

class SearchPlacesView extends StatefulWidget {
  const SearchPlacesView({Key? key}) : super(key: key);

  @override
  State<SearchPlacesView> createState() => _SearchPlacesViewState();
}

class _SearchPlacesViewState extends State<SearchPlacesView> {
  final searchPlacesViewScaffoldKey = GlobalKey<ScaffoldState>();
  Object? parameters;
  dynamic formData = {};
  SearchPlacesViewModel searchPlacesData = SearchPlacesViewModel();

  @override
  Widget build(BuildContext context) {

    parameters = ModalRoute.of(context)!.settings.arguments;
    formData = jsonDecode(jsonEncode(parameters));

    return Scaffold(
      key: searchPlacesViewScaffoldKey,
      appBar: AppBar(title: const Text("Where is located you Campaign?")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: searchPlacesData.getCameraPosition(),
            markers: searchPlacesData.markersList,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              searchPlacesData.googleMapController = controller;
              setState(() {
                searchPlacesData.updateLocalPosition();
              });
            },
          ),
          ElevatedButton(
              onPressed: () {
                _handlePressSearchButton(context);
              },
              child: const Text('Search')),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/campaignForm',
                              arguments: {
                                'address': searchPlacesData.selectedPosition.result.formattedAddress,
                                'lat': searchPlacesData.selectedPosition.result.geometry?.location.lat,
                                'lng': searchPlacesData.selectedPosition.result.geometry?.location.lng,
                                'title' : formData['title'],
                                'range' : formData['range'],
                                'payment' : formData['payment'],
                              });
                        },
                        backgroundColor: Colors.blueAccent,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handlePressSearchButton(context) async {
    //searchPlacesData.getPrediction(context,searchPlacesViewScaffoldKey.currentState);
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: FlutterConfig.get('GOOGLE_API_KEY'),
        onError: onError,
        mode: Mode.overlay,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: "Search",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.blueAccent))),
        components: [
          Component(Component.country, "it"),
          //Component(Component.country, "us"),
          //Component(Component.country, "fr"),
          //Component(Component.country, "de")
        ]);
    searchPlacesData.displayPrediction(
        p!, searchPlacesViewScaffoldKey.currentState);
  }

/*
_handleTap(LatLng point) {
    setState(() {
      searchPlacesData.markersList.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'I am a marker',
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
     ));
 });
}
*/

  void onError(PlacesAutocompleteResponse response) {
    searchPlacesViewScaffoldKey.currentState!.showBottomSheet(
        (context) => DialogView(message: response.errorMessage!));
  }
}
