import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/providers/all_campaign_provider.dart';
import 'package:mobile_crowd_sensing/providers/create_campaign_provider.dart';
import 'package:mobile_crowd_sensing/providers/my_campaign_provider.dart';
import 'package:mobile_crowd_sensing/utils/join_campaign_factory.dart';
import 'package:mobile_crowd_sensing/view_models/camera_view_model.dart';
import 'package:mobile_crowd_sensing/views/login_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_view.dart';
import 'package:mobile_crowd_sensing/views/create_campaign_form.dart';
import 'package:mobile_crowd_sensing/views/search_places_view.dart';
import 'package:mobile_crowd_sensing/views/worker_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/worker_view.dart';


Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/campaignForm': (context) => const CreateCampaignForm(),
        '/sourcer': (context) => const SourcerView(),
        '/worker': (context) => const AllCampaignProvider(),
        '/create_campaign_provider': (context) => const CampaignCreator(),
        '/map': (context) => const SearchPlacesView(),
        '/sourcer_campaigns': (context) => const SourcerCampaignView(contractAddress: [],),
        '/sourcer_campaigns_provider': (context) => const MyCampaignProvider(),
        '/join_campaign':(context) => JoinCampaignFactory.fromTypeName(context),
        '/camera':(context) => const CameraViewModel(),

      },
    );
  }
}