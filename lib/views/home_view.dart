import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/view_models/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var homeData = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Home page'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    homeData.goToSourcerView(context);
                  },
                  icon: const Icon(Icons.connect_without_contact),
                  label: Text(
                    homeData.getTitle1(),
                    style: GoogleFonts.spaceMono(
                        textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                        fontWeight: FontWeight.normal, fontSize: 16),
                  )),
              const Padding(padding: EdgeInsets.all(50)),
              TextButton.icon(
                  onPressed: () {
                    homeData.goToWorkerView(context);
                  },
                  icon: const Icon(Icons.work),
                  label: Text(
                    homeData.getTitle2(),
                    style: GoogleFonts.spaceMono(
                        textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                        fontWeight: FontWeight.normal, fontSize: 16),
                  )),
              const Padding(padding: EdgeInsets.all(50)),
              TextButton.icon(
                  onPressed: () {
                      homeData.goToVerifierView(context);
                  },
                  icon: const Icon(Icons.verified_user_sharp),
                  label: Text(
                    homeData.getTitle3(),
                    style: GoogleFonts.spaceMono(
                        textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                        fontWeight: FontWeight.normal, fontSize: 16),
                  ))
            ],
          ),
        )));
  }
}
