import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import '../controllers/create_campaign_form_controller.dart';

class CreateCampaignFormView extends StatefulWidget {
  const CreateCampaignFormView({super.key});

  @override
  CreateCampaignFormViewState createState() {
    return CreateCampaignFormViewState();
  }
}

class CreateCampaignFormViewState extends State<CreateCampaignFormView> {


  @override
  Widget build(BuildContext context) {

      return Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Create New Campaign'),
            backgroundColor: CustomColors.blue900(context),
          ),
          body: const CreateCampaignFormController());
  }
}
