import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'ipfs_client_model.dart';

class ValidateLightModel {
  static downloadFiles(hashToDownload) async {
    String? res = await IpfsClientModel.downloadItemIPFS(hashToDownload,'lights');
    if (res != null) {
      List<String> value = res.split('/');
      return value;
    }
    return null;
  }

  static Future<bool> approveOrNot(contractAddress,hash,bool status) async {
    SessionModel sessionData = SessionModel();
    print(contractAddress);
    SmartContractModel smartContractViewModel = SmartContractModel(contractAddress,'Campaign','assets/abi.json', provider: sessionData.getProvider());
    if (status) {
      print("try to validate");
      Future<dynamic> res = await smartContractViewModel.queryTransaction(
          'validateFile', [hash], null);
      if (res.toString() != "null" &&
          res.toString() != "0x0000000000000000000000000000000000000000") {
        return true;
      }
      return false;
    } else {
      print("try to not validate");
      dynamic res = await smartContractViewModel.queryTransaction(
          'notValidateFile', [hash], null);
      if (res.toString() != "null" &&
          res.toString() != "0x0000000000000000000000000000000000000000") {
        return true;
      }
      return false;
    }
  }
}