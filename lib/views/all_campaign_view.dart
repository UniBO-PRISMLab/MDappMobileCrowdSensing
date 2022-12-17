import 'package:flutter/material.dart';
import '../controller/all_campaign_controller.dart';

class AllCampaignView extends StatelessWidget {
  final String cameFrom;
  const AllCampaignView({required this.cameFrom, super.key});

  @override
  Widget build(BuildContext context) {
    return AllCampaignController(cameFrom: cameFrom,);
  }

}















