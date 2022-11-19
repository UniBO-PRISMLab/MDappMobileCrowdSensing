import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../utils/helperfunctions.dart';

class CreateCampaignProvider extends StatefulWidget {
  const CreateCampaignProvider({Key? key}) : super(key: key);

  @override
  _CreateCampaignProviderState createState() => _CreateCampaignProviderState();
}

class _CreateCampaignProviderState extends State<CreateCampaignProvider> {

  SessionViewModel sessionData = SessionViewModel();

  createCampaignWithMetamask(BuildContext context) async {
    var message = generateSessionMessage(sessionData.getSession().accounts[0]);

    if (sessionData.getConnector().connected) {
      try {

        EthereumWalletConnectProvider provider = EthereumWalletConnectProvider(sessionData.getConnector());

        launchUrlString(sessionData.getUri(), mode: LaunchMode.externalApplication);

        await provider.sendTransaction(
            from: sessionData.getUri(),
            to: FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS')
        );
        setState(() {
          Navigator.pushReplacementNamed(context, '//sourcer');
        });
      } catch (exp) {
        print("Error while sent transaction");
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
    createCampaignWithMetamask(context);
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


