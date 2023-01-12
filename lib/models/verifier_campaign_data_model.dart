import 'smart_contract_model.dart';
import 'session_model.dart';

class VerifierCampaignDataModel {
  static Future<String> getData(String contractAddress) async {
    String? fileChecked, fileCount, workersCount;
    SessionModel sessionData = SessionModel();

    late SmartContractModel smartContract;

    if (contractAddress != "0x0000000000000000000000000000000000000000") {
      smartContract = SmartContractModel(
          contractAddress: contractAddress,
          abiName: 'Campaign',
          abiFileRoot: 'assets/abi_campaign.json',
          provider: sessionData.getProvider());
      List<dynamic>? fileCountRaw =
          await smartContract.queryCall('fileCount', []);
      List<dynamic>? fileCheckedRaw =
          await smartContract.queryCall('checkedFiles', []);
      List<dynamic>? workersCountRaw =
          await smartContract.queryCall('numberOfActiveWorkers', []);

      if (fileCheckedRaw != null) {
        fileChecked = fileCheckedRaw[0].toString();
      }
      if (fileCountRaw != null) {
        fileCount = fileCountRaw[0].toString();
      }

      if (workersCountRaw != null) {
        workersCount = workersCountRaw[0].toString();
      }
    }
    return "{"
        "\"fileChecked\":\"$fileChecked\","
        "\"fileCount\":\"$fileCount\","
        "\"workersCount\":\"$workersCount\""
        "}";
  }

  static Future<List<dynamic>?> getDataFileInfo(String contractAddress) async {
    List<dynamic>? allFilesInfo;
    SessionModel sessionData = SessionModel();

    late SmartContractModel smartContract;

    if (contractAddress != "0x0000000000000000000000000000000000000000") {
      smartContract = SmartContractModel(
          contractAddress: contractAddress,
          abiName: 'Campaign',
          abiFileRoot: 'assets/abi_campaign.json',
          provider: sessionData.getProvider());

      List<dynamic>? allFilesInfoRaw =
          await smartContract.queryCall('getAllFilesInfo', []);

      if (allFilesInfoRaw != null) {
        allFilesInfo = allFilesInfoRaw[0];
      }
    }
    return allFilesInfo;
  }
}
