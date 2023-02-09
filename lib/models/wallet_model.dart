import 'package:flutter_config/flutter_config.dart';
import 'package:web3dart/credentials.dart';

import 'smart_contract_model.dart';
import 'session_model.dart';

class WalletModel {

  static Future<String> getData() async {

    String? balance,symbol;
    SessionModel sessionData = SessionModel();

    late SmartContractModel smartContract = SmartContractModel(
        contractAddress:FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),
        abiName: 'MCSfactory',
        abiFileRoot: 'assets/abi.json',
        provider: sessionData.getProvider()
    );
    EthereumAddress address = EthereumAddress.fromHex(sessionData.getAccountAddress());

    List<dynamic>? balanceRow =
    await smartContract.queryCall('balanceOf', [address]);
    List<dynamic>? symbolRow =
    await smartContract.queryCall('symbol', []);

    if (balanceRow != null) {
      balance = balanceRow[0].toString();
    }
    if (symbolRow != null) {
      symbol = symbolRow[0].toString();
    }

    return
      "{"
          "\"balance\":\"$balance\","
          "\"symbol\":\"$symbol\""
          "}";
  }

}