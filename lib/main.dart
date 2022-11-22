import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/providers/create_campaign_provider.dart';
import 'package:mobile_crowd_sensing/providers/my_campaign_provider.dart';
import 'package:mobile_crowd_sensing/views/login_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_campaign_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_view.dart';
import 'package:mobile_crowd_sensing/views/widgets/create_campaign_form.dart';
import 'package:mobile_crowd_sensing/views/widgets/search_places_view.dart';
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
        '/worker': (context) => const WorkerView(),
        '/create_campaign_provider': (context) => const CampaignCreator(),
        '/map': (context) => const SearchPlacesView(),
        '/sourcer_campaigns': (context) => const SourcerCampaignView(contractAddress: [],),
        '/sourcer_campaigns_provider': (context) => const MyCampaignProvider(),
      },
    );
  }
}