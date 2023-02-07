import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/db_session_model.dart';
import 'package:slider_button/slider_button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../utils/internet_connection.dart';
import '../utils/spalsh_screens.dart';
import 'login_metamask_controller.dart';
import '../utils/styles.dart';
import '../models/session_model.dart';
import '../views/home_view.dart';

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  bool isRunning = false;
  late SessionModel sessionData;


  @override
  void initState() {
    InternetConnection.checkInternetConnectivity();
    super.initState();
  }


  Future<void> tryToReconnect() async{
    sessionData = SessionModel();
    DbSessionModel dbSession = DbSessionModel();
    List<Session> res = await dbSession.sessions();
    if(res.isNotEmpty) {
      List<String> lis = [res[0].account];
      await sessionData.connector.approveSession(accounts: lis, chainId: res[0].chainId);
      print("Debugg::::::: ${sessionData.getAccountAddress()}");
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: tryToReconnect(),
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
            (sessionData.connector.connected)?
            Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
                        style: CustomTextStyle.merriweatherBold(context),
                      ),
                      Text(
                        '${sessionData.getAccountAddress()}',
                        style: CustomTextStyle.inconsolata(context),
                      ),
                      const SizedBox(height: 20),
                      Row(children: [
                        Text(
                          'Chain: ',
                          style: CustomTextStyle.inconsolata(context),
                        ),
                        Text(
                          sessionData
                              .getNetworkName(sessionData.connector.session.chainId),
                          style: CustomTextStyle.inconsolata(context),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      (sessionData.connector.session.chainId != 5)
                          ? Row(children: const [
                        Icon(Icons.warning,
                            color: Colors.redAccent, size: 15),
                        Text('Network not supported. Switch to '),
                        Text(
                          'Goreli Testnet',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ])
                          : const SizedBox(height: 20),
                      Center(
                          child: SliderButton(
                            action: () async {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeView()));
                            },
                            label: const Text('Slide to login'),
                            icon: Icon(Icons.arrow_forward_ios_rounded,
                                color: CustomColors.blue900(context)),
                          ))
                    ]))
                : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        CustomColors.blue900(context))),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginMetamaskController())),
                child: const Text("Connect with Metamask")),
          ],
        ));
  }
}
