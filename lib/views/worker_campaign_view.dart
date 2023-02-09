import 'package:flutter/material.dart';
import '../controllers/campaign_list_controller.dart';

class WorkerCampaignView extends StatefulWidget {
  final List<dynamic>? contractsAddresses;
  const WorkerCampaignView({Key? key, required this.contractsAddresses})
      : super(key: key);

  @override
  State<WorkerCampaignView> createState() => _WorkerCampaignViewState();
}

class _WorkerCampaignViewState extends State<WorkerCampaignView> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('List Of All Campaigns'),
          centerTitle: true,
        ),
        body: CampaignListController(contractsAddresses: widget.contractsAddresses!, goTo: '/join_campaign',)
    );
  }
}
