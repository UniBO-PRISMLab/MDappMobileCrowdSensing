import 'package:flutter/services.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

import '../views/dialog_view.dart';

class SmartContractViewModel {

  SessionViewModel sessionData = SessionViewModel();

  Future<DeployedContract> loadContract(String contractAddress) async {
    String abi = await rootBundle.loadString('assets/abi.json');
    final contract = DeployedContract(ContractAbi.fromJson(abi, "MCSfactory"), EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String contractAddress,String functionName, List<dynamic> args) async{

    final contract = await loadContract(contractAddress);
    final ethFunction = contract.function(functionName);

    EthereumWalletConnectProvider provider = EthereumWalletConnectProvider(sessionData.getConnector());
    launchUrlString(sessionData.getUri(), mode: LaunchMode.externalApplication);
    
    Transaction transaction = Transaction.callContract(contract: contract, function: ethFunction, parameters: args);

    //final result1 = await sessionData.getEthClient().sendTransaction(private key,Transaction.callContract(contract: contract, function: function, parameters: parameters))
    final result = await provider.signTransaction(
      from: sessionData.getAccountAddress(),
      to: contractAddress,
      value: BigInt.from(1), //esempio
      data: b170ad41,
    )
    List<dynamic> res = result;
    print('\x1B[31m$res\x1B[0m');
    return res[0];

  }
}























