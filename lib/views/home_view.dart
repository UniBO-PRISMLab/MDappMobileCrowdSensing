import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/views/sourcer_view.dart';
import 'package:mobile_crowd_sensing/views/wallet_view.dart';
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
          backgroundColor:CustomColors.blue900(context),
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

/*class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Home page'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Column(children: [
          SizedBox(
              height: DeviceDimension.deviceHeight(context) / 10,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: FloatingActionButton(
                      backgroundColor: CustomColors.blue900(context),
                      heroTag: 'close_btn',
                      onPressed: () {
                        Navigator.pushNamed(context, '/wallet');
                      },
                      child: Icon(
                        Icons.wallet,
                        color: CustomColors.customWhite(context),
                      ),
                    )),
              )),
              Expanded(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/sourcer');
                            },
                            icon: const Icon(Icons.connect_without_contact),
                            label: Text(
                              "Be a crowdsourcer",
                              style: CustomTextStyle.spaceMono(context),
                            )),
                        const Padding(padding: EdgeInsets.all(50)),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/worker');
                            },
                            icon: const Icon(Icons.work),
                            label: Text(
                              "Be a worker",
                              style: CustomTextStyle.spaceMono(context),
                            )),
                        const Padding(padding: EdgeInsets.all(50)),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/verifier');
                            },
                            icon: const Icon(Icons.verified_user_sharp),
                            label: Text(
                              "Be a verifier",
                              style: CustomTextStyle.spaceMono(context),
                            ))
                      ],
              ))),
        ])));
  }
}*/
