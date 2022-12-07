import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogView extends StatefulWidget {
  final String message;
  final String? goTo;
  const DialogView({Key? key, required this.message, this.goTo}) : super(key: key);

  @override
  State<DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<DialogView> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
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
                  style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.bold, fontSize: 16),
                )),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            TextButton(
                onPressed: () {
                  Future.delayed(Duration.zero, () {
                          (widget.goTo != null) ? Navigator.pushReplacementNamed(context, '/${widget.goTo}') : Navigator.of(context).pop();
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
