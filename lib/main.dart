import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/utils/verifier_campaign_data_factory.dart';
import 'package:mobile_crowd_sensing/views/all_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/close_campaign_view.dart';
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
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  final database = openDatabase(
    join(await getDatabasesPath(), 'followed_campaigns.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE campaigns(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    version: 1,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        '/sourcer_close_campaign_provider': (context) => const SourcerPastCampaignsController(),
        '/sourcer_close_campaign_service_provider': (context) => const CloseCampaignView(),
        '/wallet':(context) => const WalletView(),
        '/join_campaign':(context) => JoinCampaignFactory.fromTypeName(context),
        '/data_campaign':(context) => WorkerDataCampaignFactory.fromTypeName(context),
        "/verifier_campaign_data":(context) => VerifierDataCampaignFactory.fromTypeName(context),
        '/camera':(context) => const DataCollectionCameraView(),
        '/validate_light_view':(context) => const ValidateLightView(),
        '/validate_photo_view':(context) => const ValidatePhotoView(),
        '/current_campaign':(context) => const SourcerCampaignView(),
      },
    );
  }
}