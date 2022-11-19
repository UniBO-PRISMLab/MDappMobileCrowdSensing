import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:web3dart/web3dart.dart';

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
    final result = await sessionData.getEthClient().call(contract: contract, function: ethFunction, params: args, sender: EthereumAddress.fromHex(sessionData.getUri()));
    return result;
  }
}