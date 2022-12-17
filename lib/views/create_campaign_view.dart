import 'dart:convert';
import 'package:flutter/material.dart';
import '../controller/create_campaign_controller.dart';

class CreateCampaignView extends StatefulWidget {
  const CreateCampaignView({super.key});
  @override
  _CreateCampaignViewState createState() => _CreateCampaignViewState();
}

class _CreateCampaignViewState extends State<CreateCampaignView> {
  final createCampaignProvider = GlobalKey<ScaffoldState>();
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

    return CreateCampaignController(
      name: jsonParameters['title'], lat: jsonParameters['lat'], lng: jsonParameters['lng'], range: jsonParameters['range'], type: jsonParameters['type'], value: jsonParameters['payment'],
    );
  }


}
