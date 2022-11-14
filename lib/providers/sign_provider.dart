import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../utils/helperfunctions.dart';

class SignProvider extends StatefulWidget {
  const SignProvider({Key? key}) : super(key: key);

  @override
  _SignProviderState createState() => _SignProviderState();
}

class _SignProviderState extends State<SignProvider> {

  SessionViewModel sessionData = SessionViewModel();

  signMessageWithMetamask(BuildContext context) async {
    var message = generateSessionMessage(sessionData.getSession().accounts[0]);

    if (sessionData.getConnector().connected) {
      try {
        print("Message received");
        print(message);

        EthereumWalletConnectProvider provider = EthereumWalletConnectProvider(sessionData.getConnector());

        launchUrlString(sessionData.getUri(), mode: LaunchMode.externalApplication);

        sessionData.setSignature(await provider.personalSign( message: message, address: sessionData.getSession().accounts[0], password: ""));
        // setState(() {
          Navigator.pushReplacementNamed(context, '/login');
        // });
      } catch (exp) {
        print("Error while signing transaction");
        print(exp);
      }
    } else {
      // setState(() {
        Navigator.pushReplacementNamed(context, '/login');
      // });
    }
  }


  @override
  void initState() {
    super.initState();
    signMessageWithMetamask(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.red,
              size: 50.0,
            )
        )
    );
  }
}


