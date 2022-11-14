import 'package:flutter/material.dart';

import '../views/widgets/create_campaign_form.dart';

class SourcerViewModel {
  String appBarTitle = 'Crowdsourcer Menu';
  String title_1 = 'Create a Campaign';
  String title_2 = 'Campaign Results';


  goToCreateCampaignForm(context) {
    Navigator.pushNamed(context,'/campaignForm');
  }
}