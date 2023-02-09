import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/campaign_data_light_model.dart';
import '../models/session_model.dart';
import '../utils/styles.dart';

class CampaignDataLightController extends StatefulWidget {
  const CampaignDataLightController({Key? key}) : super(key: key);

  @override
  State<CampaignDataLightController> createState() => _CampaignDataLightControllerState();
}

class _CampaignDataLightControllerState extends State<CampaignDataLightController> {
  dynamic campaignSelectedData = {};
  Object? parameters;
  SessionModel sessionData = SessionModel();

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    campaignSelectedData = jsonDecode(jsonEncode(parameters));
    return  Container(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        width: double.maxFinite,
        child: Column(children: [
          Text(
            'Account',
            style: CustomTextStyle.merriweatherBold(context),
          ),
          Text(
            '${sessionData.getAccountAddress()}',
            style: CustomTextStyle.inconsolata(context),
          ),
          FutureBuilder(
              future: CampaignDataLightModel.preparePage(campaignSelectedData['contractAddress']),
              builder: (BuildContext context,
                  AsyncSnapshot<List<LightData>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                        child: Text('Sorry something goes wrong...'));
                  case ConnectionState.waiting:
                    return const Expanded(
                      flex: 1,
                      child: Center(
                          child: CircularProgressIndicator()),
                    );
                  default:
                    return (snapshot.data!.isNotEmpty)
                        ? _closedCampaignLightWidget(context, snapshot)
                        : Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                                  "No data for this campaign.",
                                  style: CustomTextStyle.spaceMono(
                                      context)))
                        ]));
                }
              })
        ]));
  }

  Widget _closedCampaignLightWidget(
      BuildContext context, AsyncSnapshot<List<LightData>> snapshot) {
    return Center(
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <LineSeries<LightData, String>>[
              LineSeries<LightData, String>(
                  dataSource: snapshot.data!,
                  xValueMapper: (LightData data, _) =>
                      DateFormat('dd/MM/yyyy, HH:mm').format(data.timeStamp),
                  yValueMapper: (LightData data, _) => data.value)
            ]
        )
    );
  }
}
