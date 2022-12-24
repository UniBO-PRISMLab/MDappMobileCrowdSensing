import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import 'package:mobile_crowd_sensing/views/dialog_view.dart';
import '../models/search_places_model.dart';
import 'package:google_maps_webservice/places.dart';

class SearchPlacesView extends StatefulWidget {
  const SearchPlacesView({Key? key}) : super(key: key);

  @override
  State<SearchPlacesView> createState() => _SearchPlacesViewState();
}

class _SearchPlacesViewState extends State<SearchPlacesView> {
  final searchPlacesViewScaffoldKey = GlobalKey<ScaffoldState>();
  SearchPlacesModel searchPlacesData = SearchPlacesModel();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, searchPlacesData);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Data position taken',
                    style: CustomTextStyle.spaceMonoWhite(context),
              ))
          );
          return false;
        },
    child: Scaffold(
      key: searchPlacesViewScaffoldKey,
      appBar: AppBar(
      backgroundColor: CustomColors.blue900(context),
      title: const Text("Where is located you Campaign?")),
      body: Stack(
        children: [
          GoogleMap(
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: searchPlacesData.getCameraPosition(),
            markers: searchPlacesData.markersList,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              searchPlacesData.googleMapController = controller;
              setState(() {
                searchPlacesData.updateLocalPositionAndCamera();
              });
            },
          ),
          ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.blue900(context))),
              onPressed: () {
                _handlePressSearchButton(context);
              },
              child: const Text('Search')),
        ],
      ),
    ));
  }

  Future<void> _handlePressSearchButton(context) async {
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
        ]
    );

    setState(() {
      searchPlacesData.displayPrediction(p!);
      searchPlacesData.markersList.clear();
      searchPlacesData.markersList.add(Marker(
          markerId: const MarkerId("0"),
          position: LatLng(searchPlacesData.lat, searchPlacesData.lng),
          infoWindow: InfoWindow(title: searchPlacesData.selectedPosition.result.name))
      );
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    searchPlacesViewScaffoldKey.currentState!.showBottomSheet(
        (context) => DialogView(message: response.errorMessage!));
  }
}
