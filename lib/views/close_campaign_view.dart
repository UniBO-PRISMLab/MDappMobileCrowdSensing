import 'dart:convert';
import 'package:flutter/material.dart';
import '../controllers/close_campaign_controller.dart';


class CloseCampaignView extends StatefulWidget {
  const CloseCampaignView({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CloseCampaignViewState createState() => _CloseCampaignViewState();
}

class _CloseCampaignViewState extends State<CloseCampaignView> {
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    return CloseCampaignController(address: jsonParameters['address'],);
  }


}














