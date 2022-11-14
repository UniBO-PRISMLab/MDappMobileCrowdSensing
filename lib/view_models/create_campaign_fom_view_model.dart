import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/views/widgets/search_places_view.dart';

class CreateCampaignFormViewModel {
  String appBarTitle = 'Create New Campaign';
  String snackBarText = 'Processing Data';
  String title_2 = 'Campaign Results';


  goToSearchPlacesView(context){
    Navigator.push(context,MaterialPageRoute(builder: (context) => const SearchPlacesView()));
  }
}