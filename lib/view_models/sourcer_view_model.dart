import 'package:flutter/material.dart';

class SourcerViewModel {
  String appBarTitle = 'Crowdsourcer Menu';
  String title_1 = 'Create a Campaign';
  String title_2 = 'Campaign Results';


  void goToCreateCampaignForm(BuildContext context) {
    Navigator.pushNamed(context,'/campaignForm');
  }

  void goToMyCampaign(BuildContext context) {
    Navigator.pushNamed(context,'/sourcer_campaigns_provider');
  }
}