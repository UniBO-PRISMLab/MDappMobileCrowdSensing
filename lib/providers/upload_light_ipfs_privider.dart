import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/providers/smart_contract_provider.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import '../utils/helperfunctions.dart';
import '../view_models/search_places_view_model.dart';
import '../views/dialog_view.dart';

class UploadLightIpfsProvider extends StatefulWidget {

  const UploadLightIpfsProvider({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadLightIpfsProviderState createState() => _UploadLightIpfsProviderState();
}

class _UploadLightIpfsProviderState extends State<UploadLightIpfsProvider> {
  late String path;
SessionViewModel sessionData = SessionViewModel();
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    uploadLight(jsonParameters['lights'].cast<double>(),jsonParameters['averageRelevation']);
    return const Scaffold(
        backgroundColor: Colors.white,//Colors.blue[900],
        body:  Center(
                child: SpinKitFadingCube(
                  color: Colors.purple,
                  size: 50.0,
                )),
          );
  }

  Future<void> uploadLight(List<double>? lights,double averageRelevation) async {

      path = await localPath;
      await writeLightRelevation("${DateTime.now().millisecondsSinceEpoch}/${averageRelevation.toString()}");
      try {
          SmartContractProvider smartContractViewModel = SmartContractProvider(jsonParameters['contractAddress'], 'Campaign', 'assets/abi_campaign.json', provider: sessionData.getProvider());
          SearchPlacesViewModel position = SearchPlacesViewModel();
          await position.updateLocalPosition();
          String preHash = await getOnlyHashIPFS(await localFile);
          List<dynamic> args = [preHash,BigInt.from((position.lat*10000000).round()),BigInt.from((position.lng*10000000).round())];
          await smartContractViewModel.queryTransaction('uploadFile', args, null).then((value) async => {
            if (value != "null" && value!='0x0000000000000000000000000000000000000000') {
              uploadIPFS(await localFile),
              Navigator.pushReplacementNamed(context, '/worker')
            } else {
              print('\x1B[31m [DEBUG]:::::::::::::::::::::::::: [uploadLight]$value\x1B[0m'),
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => const DialogView(message: 'position out of area')))
            }
          });
        } catch (error) {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DialogView(message: '[uploadLight]: $error')
                )
            );
          });
      }
    }
  }















