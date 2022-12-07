import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SourcerView extends StatefulWidget {
  const SourcerView({Key? key}) : super(key: key);

  @override
  State<SourcerView> createState() => _SourcerViewState();
}

class _SourcerViewState extends State<SourcerView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text("Crowdsourcer Menu"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context,'/campaignForm');
                },
                icon: const Icon(Icons.create),
                label: Text(
                  'Create a Campaign',
                  style: GoogleFonts.spaceMono(
                      textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                      fontWeight: FontWeight.normal, fontSize: 16),
                )),
                const Padding(padding: EdgeInsets.all(50)),

                TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context,'/sourcer_campaigns_provider');
                },
                icon: const Icon(Icons.dataset_rounded),
                label: Text(
                  'Current Campaign',
                  style: GoogleFonts.spaceMono(
                      textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                      fontWeight: FontWeight.normal, fontSize: 16),
                )),
                const Padding(padding: EdgeInsets.all(50)),

                TextButton.icon(
                    onPressed: () {
                          Navigator.pushReplacementNamed(context,'/sourcer_close_campaign_provider');
                    },
                    icon: const Icon(Icons.dataset_rounded),
                    label: Text(
                      'Closed Campaigns',
                      style: GoogleFonts.spaceMono(
                          textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                          fontWeight: FontWeight.normal, fontSize: 16),
                    )),
          ]),
        ));
  }
}
