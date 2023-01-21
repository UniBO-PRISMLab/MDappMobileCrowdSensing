import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';
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
  SessionModel sessionData = SessionModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionData.checkConnection();
  }
  @override
  Widget build(BuildContext context) {
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
