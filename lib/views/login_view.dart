import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login Page')),
        body: const LoginController()
    );
  }

}



