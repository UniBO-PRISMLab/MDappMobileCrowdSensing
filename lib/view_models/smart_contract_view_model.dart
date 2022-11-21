import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:web3dart/web3dart.dart';

import '../views/dialog_view.dart';

class SmartContractViewModel {

  SessionViewModel sessionData = SessionViewModel();

  Future<DeployedContract> loadContract(String contractAddress) async {
    String abi = await rootBundle.loadString('assets/abi.json');
    final contract = DeployedContract(ContractAbi.fromJson(abi, "MCSfactory"), EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<dynamic> query(BuildContext context,String contractAddress,String functionName, List<dynamic> args, BigInt value) async{

    final contract = await loadContract(contractAddress);
    final ethFunction = contract.function(functionName);

    // EthereumWalletConnectProvider provider = EthereumWalletConnectProvider(sessionData.getConnector());
    // launchUrlString(sessionData.getUri(), mode: LaunchMode.externalApplication);

    Credentials credentials = EthPrivateKey.fromHex(FlutterConfig.get('PRIVATE_KEY_METAMASK'));
    try {
      final result = await sessionData
          .getEthClient()
          .sendTransaction(credentials, Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          value: EtherAmount.inWei(value)), chainId: 5,
          fetchChainIdFromNetworkId: false);

      print('\x1B[31m$result\x1B[0m');
      return result;

    } catch (error) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => DialogView(goTo: 'sourcer', message: error.toString())));
    }
  }
}























