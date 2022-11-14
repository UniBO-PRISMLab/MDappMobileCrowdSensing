import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_crowd_sensing/views/login_view.dart';
import 'package:mobile_crowd_sensing/views/sourcer_view.dart';
import 'package:mobile_crowd_sensing/views/widgets/create_campaign_form.dart';
import 'package:mobile_crowd_sensing/views/worker_view.dart';


Future<void> main(List<String> args) async {
  await dotenv.load(fileName: ".env");
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
      },
    );
  }
}