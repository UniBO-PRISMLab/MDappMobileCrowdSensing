import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';
import 'login_metamask_controller.dart';
import '../utils/styles.dart';
import '../view_models/session_view_model.dart';
import '../views/home_view.dart';

class LoginController extends StatelessWidget{
  const LoginController({super.key});

  @override
  Widget build(BuildContext context) {
    SessionViewModel sessionData = SessionViewModel();
    sessionData.checkConnection();
    return  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/main_page_image.png',
              fit: BoxFit.fitHeight,
            ),
            (sessionData.getSession() != null) ?
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
                      Row(
                          children: [
                            Text(
                              'Chain: ',
                              style: CustomTextStyle.inconsolata(context),
                            ),
                            Text(
                              sessionData.getNetworkName(sessionData
                                  .getSession()
                                  .chainId),
                              style: CustomTextStyle.inconsolata(context),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      (sessionData
                          .getSession()
                          .chainId != 5) ?
                      Row(
                          children: const [
                            Icon(Icons.warning,
                                color: Colors.redAccent, size: 15),
                            Text('Network not supported. Switch to '),
                            Text('Goreli Testnet',
                              style: TextStyle(fontWeight: FontWeight.bold),)
                          ]) :
                      const SizedBox(height: 20),
                      SliderButton(
                        action: () async {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HomeView()));
                        },
                        label: const Text('Slide to login'),
                        icon: const Icon(Icons.check),
                      )
                    ]))
                : ElevatedButton(
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const LoginMetamaskController())),
                child: const Text("Connect with Metamask")),
          ],
        )
    );
  }
}