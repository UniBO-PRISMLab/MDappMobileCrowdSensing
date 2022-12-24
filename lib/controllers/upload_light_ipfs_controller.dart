import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/upload_light_ipfs_model.dart';
import '../views/dialog_view.dart';

class UploadLightIpfsController extends StatefulWidget {

  const UploadLightIpfsController({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadLightIpfsControllerState createState() => _UploadLightIpfsControllerState();
}

class _UploadLightIpfsControllerState extends State<UploadLightIpfsController> {
  late String path;
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
  }

  _uploadData() async{
    bool res = await UploadLightModel.uploadLight(jsonParameters['lights'].cast<double>(),
        jsonParameters['averageRelevation'],jsonParameters['contractAddress']);

    if (res) {
      setState(() {
        Navigator.pushReplacementNamed(context, '/worker');
      });
    }
    setState(() {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => const DialogView(message: 'position out of area')));
    });
  }
  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute
        .of(context)!
        .settings
        .arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    _uploadData();
    return const Scaffold(
      backgroundColor: Colors.white, //Colors.blue[900],
      body: Center(
          child: SpinKitFadingCube(
            color: Colors.purple,
            size: 50.0,
          )
      ),
    );
  }

}















