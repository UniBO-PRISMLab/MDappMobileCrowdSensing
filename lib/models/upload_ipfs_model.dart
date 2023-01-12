import 'package:mobile_crowd_sensing/models/file_manager_model.dart';
import 'package:mobile_crowd_sensing/models/search_places_model.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'ipfs_client_model.dart';
import 'dart:async';
import 'dart:io';

class UploadIpfsModel {
  static Future<String?> uploadLight(List<double>? lights,
      double averageRelevation, String contractAddress) async {
    SessionModel sessionData = SessionModel();
    await FileManagerModel.writeLightInLocalLightFile(
        "${DateTime.now().millisecondsSinceEpoch}/${averageRelevation.toString()}");
    try {
      SmartContractModel smartContractViewModel = SmartContractModel(
          contractAddress:contractAddress, abiName: 'Campaign', abiFileRoot: 'assets/abi_campaign.json',
          provider: sessionData.getProvider());
      SearchPlacesModel position = SearchPlacesModel();
      await position.updateLocalPosition();
      String? preHash = await IpfsClientModel.getOnlyHashIPFS(
          await FileManagerModel.localLightFile);
      if (preHash != null) {
        List<dynamic> args = [
          preHash,
          BigInt.from((position.lat * 10000000).round()),
          BigInt.from((position.lng * 10000000).round())
        ];
        String value = await smartContractViewModel.queryTransaction(
            'uploadFile', args, null);

        if (value != "null" &&
            value != '0x0000000000000000000000000000000000000000' &&
            !value.startsWith('JSON-RPC error')) {
          IpfsClientModel.uploadIPFS(await FileManagerModel.localLightFile);
          return 'Data uploaded';
        }
        else if (value.startsWith('JSON-RPC error -32000:')){
          return value.split('JSON-RPC error -32000:').last.toString();
        }
        else {
          return 'An error Occurred.';
        }
      }
      return null;
    } catch (error) {
      return null;
    }

  }

  static Future<String?> uploadPhotos(
      List<File> photos, String contractAddress) async {
    try {
      SessionModel sessionData = SessionModel();
      SmartContractModel smartContractViewModel = SmartContractModel(
          contractAddress:contractAddress,abiName: 'Campaign',abiFileRoot: 'assets/abi_campaign.json',
          provider: sessionData.getProvider());
      SearchPlacesModel position = SearchPlacesModel();
      await position.updateLocalPosition();
      String? preHash = await IpfsClientModel.getOnlyHashIPFSDirectory(photos);
      if (preHash != null) {
        List<dynamic> args = [
          preHash,
          BigInt.from((position.lat * 10000000).round()),
          BigInt.from((position.lng * 10000000).round())
        ];
        String value = await smartContractViewModel.queryTransaction(
            'uploadFile', args, null);
        if (value != "null" &&
            value != '0x0000000000000000000000000000000000000000' &&
            !value.startsWith('JSON-RPC error')) {
          IpfsClientModel.uploadMultipleFileIPFS(photos);
          return 'Data uploaded';
        }
        else if (value.startsWith('JSON-RPC error -32000:')){
          return value.split('JSON-RPC error -32000:').last.toString();
        }
        else {
          return 'An error Occurred.';
        }
      }
      return null;
    } catch (error) {
      return null;
    }
  }
}
