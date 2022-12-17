import 'package:flutter/material.dart';
import '../utils/styles.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

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
                    Navigator.pushNamed(context, '/sourcer');
                  },
                  icon: const Icon(Icons.connect_without_contact),
                  label: Text("Be a crowdsourcer", style: CustomTextStyle.spaceMono(context),)),
              const Padding(padding: EdgeInsets.all(50)),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/worker');
                  },
                  icon: const Icon(Icons.work),
                  label: Text(
                    "Be a worker",
                    style: CustomTextStyle.spaceMono(context),
                  )),
              const Padding(padding: EdgeInsets.all(50)),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/verifier');
                  },
                  icon: const Icon(Icons.verified_user_sharp),
                  label: Text("Be a verifier", style: CustomTextStyle.spaceMono(context),))
            ],
          ),
        )));
  }
}
