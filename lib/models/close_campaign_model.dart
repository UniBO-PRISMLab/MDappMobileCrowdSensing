import 'smart_contract_model.dart';
import 'session_model.dart';

class CloseCampaignModel {
  static Future<String> closeMyCampaign(String address) async {
    SessionModel sessionData = SessionModel();
    SmartContractModel smartContractViewModel = SmartContractModel(
        contractAddress: address,
        abiName: 'Campaign',
        abiFileRoot: 'assets/abi_campaign.json',
        provider: sessionData.getProvider());
    dynamic res = await smartContractViewModel.queryTransaction(
        'closeCampaignAndPay', [], null);

    if (res.toString() != "null" &&
        res.toString() != "0x0000000000000000000000000000000000000000" &&
        !res.startsWith('JSON-RPC error')) {
      return 'Campaign Closed';
    }else if (res.startsWith('JSON-RPC error -32000:')){
      return res.split('JSON-RPC error -32000:').last.toString();
    }
    else {
      return 'An error Occurred.';
    }
  }
}
