import 'package:flutter/material.dart';
import '../controllers/verifier_campaign_controller.dart';


class VerifierCampaignView extends StatefulWidget {
  final List<dynamic>? contractsAddresses;
  const VerifierCampaignView({Key? key, required this.contractsAddresses})
      : super(key: key);

  @override
  State<VerifierCampaignView> createState() => _VerifierCampaignViewState();
}

class _VerifierCampaignViewState extends State<VerifierCampaignView> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('List Of All Campaigns to Verify'),
          centerTitle: true,
        ),
        body: VerifierCampaignController(widget.contractsAddresses)
    );
  }
}
