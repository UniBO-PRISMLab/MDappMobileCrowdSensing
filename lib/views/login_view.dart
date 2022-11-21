import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/providers/login_provider.dart';
import 'package:mobile_crowd_sensing/providers/sign_provider.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/views/home_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slider_button/slider_button.dart';

import '../utils/helperfunctions.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    SessionViewModel sessionData = SessionViewModel();
    sessionData.getConnector().on(
        'connect',
            (session) =>
                setState(() {sessionData.setSession(session);},
        ));
    sessionData.getConnector().on(
        'session_update',
            (payload) => setState(() {
              sessionData.setSession(payload);
          print(sessionData.getAccountAddress());
          print(sessionData.getSession().chainId);
        }));
    sessionData.getConnector().on(
        'disconnect',
            (payload) => setState(() {
              sessionData.setSession(null);
        }));

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
                      style: GoogleFonts.merriweather(
                          fontWeight: FontWeight.bold, fontSize: 16),
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    (sessionData.getSession().chainId != 5) ? Row(
                      children: const [
                        Icon(Icons.warning,
                            color: Colors.redAccent, size: 15),
                        Text('Network not supported. Switch to '),
                        Text('Goreli Testnet', style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    )  : (sessionData.getSignature() == null) ? Container(alignment: Alignment.center,
                      child:
                      ElevatedButton(
                          onPressed: () => {
                            setState (
                                    () {
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const SignProvider()));
                                    }
                            )
                          },
                          child: const Text('Sign Message')),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text("Signature: ", style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, fontSize: 16),),
                            Text(truncateString(sessionData.getSignature().toString(), 4, 2), style: GoogleFonts.inconsolata(fontSize: 16))
                          ],
                        ),
                        const SizedBox(height: 20),
                        SliderButton(
                          action: () async {
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const HomeView()));
                          },
                          label: const Text('Slide to login'),
                          icon: const Icon(Icons.check),
                        )
                      ],
                    )
                  ],
                ))
                : ElevatedButton(
                onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => LoginProvider())),
                child: const Text("Connect with Metamask")),
          ],
        ),
      ),
    );
  }
}
