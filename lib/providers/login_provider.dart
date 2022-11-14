import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginProvider extends StatefulWidget {
  const LoginProvider({super.key});

  @override
  _LoginProviderState createState() => _LoginProviderState();
}

class _LoginProviderState extends State<LoginProvider> {
  SessionViewModel sessionData = SessionViewModel();

  loginUsingMetamask() async {
    if (!sessionData.getConnector().connected) {
      try {
        var session = await sessionData.getConnector().createSession(
            onDisplayUri: (uri) async {
          sessionData.setUri(uri);
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          sessionData.setSession(session);
          Navigator.pushReplacementNamed(context, '/login');
        });
      } catch (exp) {
        print(exp);
      }
    } else {
      setState(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loginUsingMetamask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
          color: Colors.yellow,
          size: 50.0,
        )));
  }
}
