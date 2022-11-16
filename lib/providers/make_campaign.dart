import 'dart:html';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:web3dart/web3dart.dart';
import '../view_models/session_view_model.dart';

class CampaignMaker extends StatefulWidget {
  const CampaignMaker({super.key});

  @override
  State<CampaignMaker> createState() => _CampaignMakerState();
}

class _CampaignMakerState extends State<CampaignMaker> {
/*
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        'https://mainnet.infura.io/v3/5074605772bb4bc4b6970d2ce999efca',
        httpClient);

    createContract(myAddress);
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {}

  Future<void> createContract(
    String targetAddress,
  ) async {
    EthereumAddress ethAddress = EthereumAddress.fromHex(targetAddress);
  }
*/
  late Client httpClient;
  late Web3Client ethClient;

  final myAddress = SessionViewModel().getAccountPrivateKey();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
