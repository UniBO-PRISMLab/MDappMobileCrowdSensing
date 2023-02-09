import 'package:flutter/material.dart';
import '../controllers/all_campaign_controller.dart';
import '../models/search_places_model.dart';
import '../utils/spalsh_screens.dart';

class AllCampaignView extends StatelessWidget {
  final String cameFrom;
  const AllCampaignView({required this.cameFrom, super.key});

  Future<bool?> _getPermission() async {
    SearchPlacesModel p = SearchPlacesModel();
    return await p.getPermissions();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _getPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return CustomSplashScreen.fadingCubeBlueBg(context);
            default:
              return (snapshot.data == true)? AllCampaignController(cameFrom: cameFrom,) : const Center(child: Text('Position permission denied.'));
          }
        }
    );

  }

}















