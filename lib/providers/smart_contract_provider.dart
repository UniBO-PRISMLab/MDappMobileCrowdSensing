import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';
import '../views/dialog_view.dart';

class SmartContractProvider extends CustomTransactionSender{
  SmartContractProvider(this.contractAddress, this.abiName, this.abiFileRoot, {required this.provider});
  final EthereumWalletConnectProvider provider;

  final String contractAddress;
  final String abiName;
  final String abiFileRoot;
  SessionViewModel sessionData = SessionViewModel();

  Future<DeployedContract> loadContract(String contractAddress) async {
    String abi = await rootBundle.loadString(abiFileRoot);
    final contract = DeployedContract(ContractAbi.fromJson(abi, abiName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<dynamic> queryTransaction(String functionName, List<dynamic> args, BigInt? value) async {
    try {
      sessionData.checkConnection();
      print("[Transaction]:::::::::::::::::::::::::::::::::::::: [function]: $functionName [args]: $args");
      final contract = await loadContract(contractAddress);
      final ethFunction = contract.function(functionName);
      final transaction = Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          value: (value != null) ? EtherAmount.inWei(value) : null
      );
      launchUrlString(sessionData.getUri(), mode: LaunchMode.externalApplication);
      final txBytes = await sendTransaction(transaction);
      return txBytes;
    } catch (error) {
      print('\x1B[31m [queryTransaction]:::::::: $error\x1B[0m');
    }
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    try {
      final hash = await provider.sendTransaction(
        from: sessionData.getAccountAddress(),
        to: transaction.to?.hex,
        data: transaction.data,
        gas: transaction.maxGas,
        gasPrice: transaction.gasPrice?.getInWei,
        value: transaction.value?.getInWei,
        nonce: transaction.nonce,
      );
      return hash;
    } catch (e) {
      print('\x1B[31m function-[sendTransaction] $e\x1B[0m');
      return 'null';
    }
  }

  Future<List<dynamic>?> queryCall(BuildContext context, String functionName, List<dynamic> args, BigInt? value, String? goToOnFail) async {
    try {
      sessionData.checkConnection();
      final contract = await loadContract(contractAddress);
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

  @override
  // TODO: implement address
  EthereumAddress get address => throw UnimplementedError();

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  @override
  MsgSignature signToEcSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToEcSignature
    throw UnimplementedError();
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }
}
