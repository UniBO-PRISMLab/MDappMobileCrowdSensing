import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/view_models/smart_contract_view_model.dart';
import 'package:mobile_crowd_sensing/views/widgets/search_places_view.dart';

class CreateCampaignFormViewModel extends StatefulWidget {
  String appBarTitle = 'Create New Campaign';
  String snackBarText = 'Processing Data';
  String title_2 = 'Campaign Results';
  SessionViewModel sessionData = SessionViewModel();
  SmartContractViewModel smartContractViewModel = SmartContractViewModel();

  CreateCampaignFormViewModel({super.key});
  @override
  _CreateCampaignFormViewModelState createState() =>
      _CreateCampaignFormViewModelState();

  goToSearchPlacesView(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SearchPlacesView()));
  }

  Future<void> createCampaign(String name, int lat, int lng, int range) async {
    List<dynamic> result = await smartContractViewModel.query(
        FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),
        'createCampaign',
        [name, lat, lng, range]);
    print(result);
  }
}

class _CreateCampaignFormViewModelState
    extends State<CreateCampaignFormViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
          color: Colors.green,
          size: 50.0,
        )));
  }
}
