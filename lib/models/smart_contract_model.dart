import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/nonce_manager.dart';

class SmartContractModel extends CustomTransactionSender{
  SmartContractModel({required this.contractAddress, required this.abiName, required this.abiFileRoot, required this.provider});
  final EthereumWalletConnectProvider provider;

  final String contractAddress;
  final String abiName;
  final String abiFileRoot;

  Future<DeployedContract> loadContract(String contractAddress) async {
    String abi = await rootBundle.loadString(abiFileRoot);
    final contract = DeployedContract(ContractAbi.fromJson(abi, abiName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<dynamic> queryTransaction(String functionName, List<dynamic> args, BigInt? value) async {
    SessionModel session = SessionModel();
    try {
      //SessionModel().checkConnection();
      int nonce = await SessionModel().ethClient.getTransactionCount(EthereumAddress.fromHex(session.getAccountAddress()));
      final contract = await loadContract(contractAddress);
      final ethFunction = contract.function(functionName);
      Transaction transaction = Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          nonce: nonce,
          value: (value != null) ? EtherAmount.inWei(value) : null
      );
      print('\x1B[31m nonce: $nonce gasPrice: ${transaction.gasPrice} maxGas: ${transaction.maxGas} \x1B[0m');

      launchUrlString(session.uri, mode: LaunchMode.externalApplication);
      final txBytes = await sendTransaction(transaction);
      return txBytes;
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31m [queryTransaction]:::::::: $e\x1B[0m');
      }
      return e.toString();
    }
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    SessionModel session = SessionModel();

    try {
      final hash = await provider.sendTransaction(
        from: session.getAccountAddress(),
        to: transaction.to?.hex,
        data: transaction.data,
        gas: transaction.maxGas,
        gasPrice: transaction.gasPrice?.getInWei,
        value: transaction.value?.getInWei,
        nonce: transaction.nonce,
      );
      return hash;
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31m function-[sendTransaction] $e\x1B[0m');
      }
      return e.toString();
    }
  }

  Future<List<dynamic>?> queryCall(String functionName, List<dynamic> args) async {
    SessionModel session = SessionModel();
    try {
      final contract = await loadContract(contractAddress);
      final ethFunction = contract.function(functionName);
      final result = await session.ethClient.call(
          sender: EthereumAddress.fromHex(session.getAccountAddress()),
          contract: contract,
          function: ethFunction,
          params: args);
      List<dynamic> res = result;
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31m$e\x1B[0m');
      }
      return null;
    }
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
