import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

class DialogView extends StatefulWidget {
  final String message;
  const DialogView({Key? key, required this.message}) : super(key: key);

  @override
  State<DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<DialogView> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  widget.message,
                  style: CustomTextStyle.merriweatherBold(context)
                )),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            TextButton(
                onPressed: () {
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                  });
                },
                child: Text(
                  'Got It!',
                  style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
