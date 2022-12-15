import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/providers/login_provider.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/views/home_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slider_button/slider_button.dart';

import '../utils/styles.dart';
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    SessionViewModel sessionData = SessionViewModel();
    sessionData.checkConnection();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
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
                      style: GoogleFonts.inconsolata(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Chain: ',
                          style: GoogleFonts.merriweather(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          sessionData.getNetworkName(sessionData.getSession().chainId),
                          style: GoogleFonts.inconsolata(fontSize: 16),
                        ),
                      ]),
                    const SizedBox(height: 20),
                    (sessionData.getSession().chainId != 5) ?
                      Row(
                        children: const [
                        Icon(Icons.warning,
                            color: Colors.redAccent, size: 15),
                        Text('Network not supported. Switch to '),
                        Text('Goreli Testnet', style: TextStyle(fontWeight: FontWeight.bold),)
                        ]):
                        const SizedBox(height: 20),
                        SliderButton(
                          action: () async {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeView()));
                          },
                          label: const Text('Slide to login'),
                          icon: const Icon(Icons.check),
                        )
                      ]))
                : ElevatedButton(
                onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const LoginProvider())),
                child: const Text("Connect with Metamask")),
          ],
        ),
      ),
    );
  }
}
