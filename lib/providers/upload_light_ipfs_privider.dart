import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ipfs_client_flutter/ipfs_client_flutter.dart';
import '../utils/helperfunctions.dart';
import '../views/dialog_view.dart';
import 'package:http/http.dart' as http;

class UploadLightIpfsProvider extends StatefulWidget {

  final List<double> lights;
  final double averageRelevation;
  const UploadLightIpfsProvider(this.lights, this.averageRelevation, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadLightIpfsProviderState createState() => _UploadLightIpfsProviderState();
}

class _UploadLightIpfsProviderState extends State<UploadLightIpfsProvider> {
  late String path;

  @override
  void initState() {
    super.initState();
    uploadLight();

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,//Colors.blue[900],
        body:  Center(
                child: SpinKitFadingCube(
                  color: Colors.purple,
                  size: 50.0,
                )),
          );
  }

  Future<void> uploadLight() async {

      path = await localPath;
      await writeLightRelevation(widget.averageRelevation.toString());
      try {
        upload(await localFile);
    } catch (error) {
      print('\x1B[31m$error\x1B[0m');
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DialogView(message: error.toString())
            )
        );
      });
    }
  }
}














