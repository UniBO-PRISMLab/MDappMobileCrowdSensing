import 'dart:io';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/models/db_session_model.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/utils/internet_connection.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import 'package:mobile_crowd_sensing/utils/verifier_campaign_data_factory.dart';
import 'package:mobile_crowd_sensing/views/all_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/create_campaign_form_view.dart';
import 'package:mobile_crowd_sensing/controllers/sourcer_past_campaigns_controller.dart';
import 'package:mobile_crowd_sensing/utils/worker_campaign_data_factory.dart';
import 'package:mobile_crowd_sensing/utils/join_campaign_factory.dart';
import 'package:mobile_crowd_sensing/views/camera_view.dart';
import 'package:mobile_crowd_sensing/views/home_view.dart';
import 'package:mobile_crowd_sensing/views/login_view.dart';
import 'package:mobile_crowd_sensing/views/my_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_view.dart';
import 'package:mobile_crowd_sensing/views/search_places_view.dart';
import 'package:mobile_crowd_sensing/views/validate_light_view.dart';
import 'package:mobile_crowd_sensing/views/validate_photo_view.dart';
import 'package:mobile_crowd_sensing/views/wallet_view.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';

class LifecycleWatcher extends StatefulWidget {
  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

      if(state == AppLifecycleState.detached) {
        print('\x1B[31m[STATUS APP] : ${state.toString()}\x1B[0m');
        SessionModel sessionModel = SessionModel();
        sessionModel.connector.killSession();
      }
  }

  @override
  Widget build(BuildContext context) {
      return const MyApp();
  }
}



Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  ConnectivityResult initialStateInternet = await Connectivity().checkConnectivity();

  if (initialStateInternet == ConnectivityResult.none) {
    runApp(const NoConnection());
  } else {
    return runApp(Center(child: LifecycleWatcher()));
  }

}

class NoConnection extends StatelessWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
          child: SizedBox(
            height: 400.0,
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        "No internet Connection",
                        style: CustomTextStyle.spaceMonoBold(context)
                    )),
                const Padding(padding: EdgeInsets.only(top: 50.0)),

                Column(
                  children: [
                    FlipCard(
                      direction: FlipDirection.VERTICAL, // default
                      front: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/coin_back.png', width: 150, height: 150),
                        ],
                      ),
                      back: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/coin.png', width: 150, height: 150),
                        ],
                      ),
                    ),
                  ],
                ),

                TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.blue900(context))),
                    onPressed: () {
                      exit(0);
                    },
                    child: Text(
                      'See you next time!',
                      style: CustomTextStyle.spaceMonoWhite(context)
                    ))
              ],
            ),
          ),
        )
    );
  }
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var subscription;

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() =>  {
        InternetConnection.connectionStatus = result,
      });
      InternetConnection.checkInternetConnectivity();
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomeView(),
        '/login': (context) => const LoginView(),
        '/campaignForm': (context) => const CreateCampaignFormView(),
        '/sourcer': (context) => const SourcerView(),
        '/worker': (context) => const AllCampaignView(cameFrom: 'worker'),
        '/verifier': (context) => const AllCampaignView(cameFrom: 'verifier'),
        '/map': (context) => const SearchPlacesView(),
        '/sourcer_campaigns_provider': (context) => const MyCampaignView(),
        '/sourcer_close_campaign_provider': (context) =>
            const SourcerPastCampaignsController(),
        '/wallet': (context) => const WalletView(),
        '/join_campaign': (context) =>
            JoinCampaignFactory.fromTypeName(context),
        '/data_campaign': (context) =>
            WorkerDataCampaignFactory.fromTypeName(context),
        "/verifier_campaign_data": (context) =>
            VerifierDataCampaignFactory.fromTypeName(context),
        '/camera': (context) => const DataCollectionCameraView(),
        '/validate_light_view': (context) => const ValidateLightView(),
        '/validate_photo_view': (context) => const ValidatePhotoView(),
        '/current_campaign': (context) => const SourcerCampaignView(),
      },
    );
  }
}
