import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/controllers/login_controller.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: CustomColors.blue900(context),
            title: const Text('Login Page')),
        body: const LoginController()
    );
  }

}



