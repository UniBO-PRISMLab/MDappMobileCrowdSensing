import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';

import '../view_models/smart_contract_view_model.dart';

class SourcerCampaignView extends StatelessWidget {
  final List<dynamic> contractAddress;

  const SourcerCampaignView({Key? key, required this.contractAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Your Camapaigns'),
          centerTitle: true,
        ),
        body: (contractAddress.isNotEmpty)
            ? Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                height: 220,
                width: double.maxFinite,
                child: Column(
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: contractAddress.length,
                        itemBuilder: (context, index) {

                          SmartContractViewModel smartContractViewModel = SmartContractViewModel(contractAddress[index].toString(),'Campaign','assets/abi_campaign.json');

                          String name = smartContractViewModel.queryCall(context, 'name', [], null, null).toString();
                          return Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Stack(children: <Widget>[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Stack(
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[ //loop
                                                  Text(name),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          );
                        }),
                  ],
                ),
              )
            : const Center(
                child: Text('No active campaign at the moment...'),
              ));
  }
}
