import 'package:flutter/material.dart';
import '../controllers/sourcer_closed_campaign_controller.dart';
import '../utils/styles.dart';

class SourcerClosedCampaignView extends StatefulWidget {
  final List<dynamic>? contractAddress;

  const SourcerClosedCampaignView({Key? key, required this.contractAddress})
      : super(key: key);

  @override
  State<SourcerClosedCampaignView> createState() => _SourcerClosedCampaignViewState();
}

class _SourcerClosedCampaignViewState extends State<SourcerClosedCampaignView> {

  @override
  Widget build(BuildContext context) {
    List? contractAddress = widget.contractAddress;

    print("DEBUG  sourcer_closed_campaign_view:::: ${contractAddress.toString()}");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
          title: const Text('Yours Past Campaigns'),
          centerTitle: true,
        ),
        body: (contractAddress != null && contractAddress.isNotEmpty) ?
            SourcerClosedCampaignController(contractAddress) :
        Center(child: Text('No campaigns at the moment...',style: CustomTextStyle.spaceMono(context),))
    );
  }
}
