import 'package:big_dart/big_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import '../models/smart_contract_model.dart';
import '../utils/styles.dart';

class ClaimCampaignController extends StatefulWidget {
  const ClaimCampaignController({Key? key}) : super(key: key);

  @override
  State<ClaimCampaignController> createState() => _ClaimCampaignControllerState();
}

class _ClaimCampaignControllerState extends State<ClaimCampaignController> {
  SessionModel session = SessionModel();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _getClaimData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                  child: Text('Sorry something goes wrong...'));
            case ConnectionState.waiting:
              return Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  width: double.maxFinite,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ]));
            default:
              return _claimCardWidget(context, snapshot);
          }
        });
  }

  Future<List<dynamic>> _getClaimData() async {

    SmartContractModel smartContractViewModel = SmartContractModel(
        contractAddress: FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),
        abiName: 'MCSfactory',
        abiFileRoot: 'assets/abi.json',
        provider: session.getProvider());
    List<dynamic>? res =
    await smartContractViewModel.queryCall('getCampaignsToClaim', []);
    if (res != null) {
      return res[0];
    }
    return [];
  }

  Widget _claimCardWidget(
      BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
    return Expanded(child:
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (snapshot.data != null) ? snapshot.data!.length : 0,
              itemBuilder: (context, index) {
                List current = snapshot.data![index];

                String address = current[0].toString();
                String role = current[1].toString();
                String reward = current[2].toString();
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Want to Claim?'),
                        content: Text('you will recive:\n${(Big(reward.toString())/Big(1000000000000000000)).toString()} MCSCoin'),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              }),
                          TextButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                SmartContractModel smartContractViewModel = SmartContractModel(
                                    contractAddress: address,
                                    abiName: 'Campaign',
                                    abiFileRoot: 'assets/abi_campaign.json',
                                    provider: session.getProvider());
                                dynamic res = await smartContractViewModel.queryTransaction("withdrawCredits", [], null);
                                if (res.toString() != "null" &&
                                    res.toString() != "0x0000000000000000000000000000000000000000" &&
                                    !res.startsWith('JSON-RPC error')) {
                                  if(!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                        'Claimed!',
                                        style: CustomTextStyle
                                            .spaceMonoWhite(context),
                                      )));
                                }else if (res.startsWith('JSON-RPC error -32000:')){
                                  if(!mounted) return;

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                        res.split('JSON-RPC error -32000:').last.toString(),
                                        style: CustomTextStyle
                                            .spaceMonoWhite(context),
                                      )));
                                }
                                else {
                                  if(!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                        "An error occurred",
                                        style: CustomTextStyle
                                            .spaceMonoWhite(context),
                                      )));
                                }
                                setState(() {
                                  Navigator.of(ctx).pop(false);
                                });
                              }),
                        ],
                      ),
                    );
                  },
                  child: Card(
                    shadowColor: CustomColors.blue600(context),
                    color: CustomColors.customWhite(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child:  Column(
                              children: <Widget>[
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Column(children: [
                                      Text(
                                        "Campaign Address: ",
                                        style: CustomTextStyle.spaceMonoBold(context),
                                      ),
                                      Text(
                                        address,
                                        style: CustomTextStyle.spaceMono(context),
                                      )
                                    ])),
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Row(children: [
                                      Text(
                                        "Role: ",
                                        style: CustomTextStyle.spaceMonoBold(context),
                                      ),
                                      Text(
                                        role,
                                        style: CustomTextStyle.spaceMono(context),
                                      )
                                    ])),
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Row(children: [
                                      Text(
                                        "Reward: ",
                                        style: CustomTextStyle.spaceMonoBold(context),
                                      ),
                                      Text(
                                        "${Big(reward).div(Big("1000000000000000000")).toString()} MCScoin",
                                        style: CustomTextStyle.spaceMono(context),
                                      )
                                    ])),
                              ],
                            ),
                          )
                        ])),
                  ),
                );
              }));
  }
}
