import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_crowd_sensing/views/sourcer_view.dart';
import 'package:mobile_crowd_sensing/views/wallet_view.dart';
import '../models/search_places_model.dart';
import '../utils/styles.dart';
import 'all_campaign_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _renderThis() {

    switch (_selectedIndex){
      case 1:
        return const SourcerView();
      case 2:
        return const AllCampaignView(cameFrom: 'worker');
      case 3:
        return const AllCampaignView(cameFrom: 'verifier');
      default:
        return const WalletView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _renderThis(),
        bottomNavigationBar:
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: CustomColors.blue900(context),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home,color: CustomColors.customWhite(context),),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.connect_without_contact,color: CustomColors.customWhite(context),),
              label: 'crowdsourcer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work,color: CustomColors.customWhite(context)),
              label: 'worker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.verified_user_rounded, color: CustomColors.customWhite(context),),
              label: 'verifier',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: CustomColors.blue600(context),
          onTap: _onItemTapped,

        ),
    );
  }

}
