import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const CustomError({
    Key? key,
    required this.errorDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.red,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(
              "Session Killed From Wallet!",
              style: CustomTextStyle.spaceMonoBold(context),
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.signal_wifi_connected_no_internet_4_outlined),
                label: Text(
                  "Back to Login.",
                  style: CustomTextStyle.spaceMono(context),
                ),

            ),

          ]),
        ));
  }
}
