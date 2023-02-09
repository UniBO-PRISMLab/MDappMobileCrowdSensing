import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/db_session_model.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../utils/internet_connection.dart';
import '../utils/spalsh_screens.dart';
import 'login_check_connection_controller.dart';
import '../models/session_model.dart';

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  bool isRunning = false;
  late SessionModel sessionData = SessionModel();
  bool gate = false;

  @override
  void initState() {
    InternetConnection.checkInternetConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sessionData.instantiateConnector(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return CustomSplashScreen.fadingCubeBlueBg(context);
            default:
              return _buildPage();
          }
        }
    );
  }


  Widget _buildPage() {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/main_page_image.png',
              fit: BoxFit.fitHeight,
            ),
            const LoginCheckConnectionController()
    ]));
  }
}
