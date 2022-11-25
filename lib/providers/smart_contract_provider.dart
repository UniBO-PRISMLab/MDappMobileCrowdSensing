import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:web3dart/web3dart.dart';
import '../views/dialog_view.dart';

class SmartContractProvider {
  final String contractAddress;
  final String abiName;
  final String abiFileRoot;
  SmartContractProvider(this.contractAddress, this.abiName, this.abiFileRoot);
  SessionViewModel sessionData = SessionViewModel();

  Future<DeployedContract> loadContractFactory(String contractAddress) async {
    String abi = await rootBundle.loadString(abiFileRoot);
    final contract = DeployedContract(ContractAbi.fromJson(abi, abiName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<dynamic> queryTransaction(
      BuildContext context,
      String functionName,
      List<dynamic> args,
      BigInt? value,
      String? goToOnFail) async {
    try {
      final contract = await loadContractFactory(contractAddress);
      final ethFunction = contract.function(functionName);


      Credentials credentials = EthPrivateKey.fromHex(sessionData.getSignature());//FlutterConfig.get('PRIVATE_KEY_METAMASK'));
      //final credentials = WalletConnectEthereumCredentials(provider: _provider);


      final result = await sessionData.getEthClient().sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: ethFunction,
              parameters: args,
              value: (value != null) ? EtherAmount.inWei(value) : null),
          chainId: 5,
          fetchChainIdFromNetworkId: false);

      print('\x1B[31m$result\x1B[0m');
      return result;
    } catch (error) {
      print('\x1B[31m$error\x1B[0m');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DialogView(goTo: goToOnFail, message: error.toString())));
    }
  }

  Future<List<dynamic>?> queryCall(
      BuildContext context,
      String functionName,
      List<dynamic> args,
      BigInt? value,
      String? goToOnFail) async {
    try {

      final contract = await loadContractFactory(contractAddress);
      final ethFunction = contract.function(functionName);

      final result = await sessionData.getEthClient().call(
          contract: contract,
          function: ethFunction,
          params: args);

      print('DEBUG:::::::::::::::::::::::::::[queryCall]:  $result');
      List<dynamic> res = result;
      return res;
    } catch (error) {
      print('\x1B[31m$error\x1B[0m');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DialogView(goTo: goToOnFail, message: error.toString())));
    }
    return null;
  }
}
