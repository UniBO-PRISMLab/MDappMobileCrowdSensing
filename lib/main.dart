import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/views/all_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/close_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/create_campaign_view.dart';
import 'package:mobile_crowd_sensing/providers/my_campaign_provider.dart';
import 'package:mobile_crowd_sensing/providers/sourcer_past_campaigns_provider.dart';
import 'package:mobile_crowd_sensing/controller/upload_light_ipfs_controller.dart';
import 'package:mobile_crowd_sensing/utils/campaign_data_factory.dart';
import 'package:mobile_crowd_sensing/utils/join_campaign_factory.dart';
import 'package:mobile_crowd_sensing/view_models/camera_view_model.dart';
import 'package:mobile_crowd_sensing/views/home_view.dart';
import 'package:mobile_crowd_sensing/views/login_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_view.dart';
import 'package:mobile_crowd_sensing/views/create_campaign_form.dart';
import 'package:mobile_crowd_sensing/views/search_places_view.dart';


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
        '/home': (context) => const HomeView(),
        '/login': (context) => const LoginView(),
        '/campaignForm': (context) => const CreateCampaignForm(),
        '/sourcer': (context) => const SourcerView(),
        '/worker': (context) => const AllCampaignView(cameFrom: 'worker'),
        '/verifier': (context) => const AllCampaignView(cameFrom: 'verifier'),
        '/create_campaign_provider': (context) => const CreateCampaignView(),
        '/upload_light': (context) => const UploadLightIpfsController(),
        '/map': (context) => const SearchPlacesView(),
        '/sourcer_campaigns_provider': (context) => const MyCampaignProvider(),
        '/sourcer_close_campaign_provider': (context) => const ClosedCampaignProvider(),
        '/sourcer_close_campaign_service_provider': (context) => const CloseCampaignView(),
        '/join_campaign':(context) => JoinCampaignFactory.fromTypeName(context),
        '/camera':(context) => const CameraViewModel(),
        '/data_campaign':(context) => CampaignDataFactory.fromTypeName(context),
      },
    );
  }
}