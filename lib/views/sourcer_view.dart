import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/sourcer_view_model.dart';

class SourcerView extends StatefulWidget {
  const SourcerView({Key? key}) : super(key: key);

  @override
  State<SourcerView> createState() => _SourcerViewState();
}

class _SourcerViewState extends State<SourcerView> {
  SourcerViewModel sourcerData = SourcerViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(sourcerData.appBarTitle),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [TextButton.icon(
                onPressed: () {
                  sourcerData.goToCreateCampaignForm(context);
                },
                icon: const Icon(Icons.create),
                label: Text(
                  sourcerData.title_1,
                  style: GoogleFonts.spaceMono(
                      textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                      fontWeight: FontWeight.normal, fontSize: 16),
                )),
                const Padding(padding: EdgeInsets.all(50)),

                TextButton.icon(
                onPressed: () {
                  sourcerData.goToMyCampaign(context);
                },
                icon: const Icon(Icons.dataset_rounded),
                label: Text(
                  sourcerData.title_2,
                  style: GoogleFonts.spaceMono(
                      textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                      fontWeight: FontWeight.normal, fontSize: 16),
                )),
          ]),
        ));
  }
}
