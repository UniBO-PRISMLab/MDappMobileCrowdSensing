import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/models/login_metamask_model.dart';
import 'package:mobile_crowd_sensing/utils/spalsh_screens.dart';

class LoginMetamaskController extends StatefulWidget {
  const LoginMetamaskController({super.key});

  @override
  _LoginMetamaskControllerState createState() => _LoginMetamaskControllerState();
}

class _LoginMetamaskControllerState extends State<LoginMetamaskController> {
  @override
  void initState() {
    super.initState();
    _connect(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen.fadingCubeBlueBg(context);
  }

  _connect(BuildContext context) async{
    await LoginMetamaskModel.loginUsingMetamask(context).then((value) => {
      Navigator.pushReplacementNamed(context, '/login')
    });
  }
}
