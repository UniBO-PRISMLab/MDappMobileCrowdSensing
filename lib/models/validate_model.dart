import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobile_crowd_sensing/models/search_places_model.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'ipfs_client_model.dart';

class ValidateModel {
  static downloadLightFiles(hashToDownload) async {
    String? res = await IpfsClientModel.downloadItemIPFS(hashToDownload, 'lights');

    if (res != null) {
      List<String> value = res.split('/');
      return value;
    }
    return null;
  }

  static Future<Stream<FileSystemEntity>?> downloadPhotosFiles(
      hashToDownload) async {
    Stream<FileSystemEntity>? res = await IpfsClientModel.downloadDirectoryIPFS(hashToDownload, 'photos');
    return res;
  }

  static Future<List<dynamic>> getFileData(
      String ipfsHash, String contractAddress) async {
    SessionModel sessionData = SessionModel();
    SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();

    List<dynamic> out = [];

    SmartContractModel smartContractViewModel = SmartContractModel(
        contractAddress: contractAddress,
        abiName: 'Campaign',
        abiFileRoot: 'assets/abi_campaign.json',
        provider: sessionData.getProvider());
    List<dynamic>? res =
        await smartContractViewModel.queryCall('files', [ipfsHash]);

    if (res != null) {
      out = res;
      if (kDebugMode) {
        print("DEB: ${res.toString()}");
      }
      out.add(
          (await searchPlacesViewModel.getReadebleLocationFromLatLng(
              (double.parse(res[5].toString())) / 10000000,
              (double.parse(res[6].toString())) / 10000000))
              .toString()
              .replaceAll(RegExp(r'[^\w\s]+'), ''));
    }
    return out;
  }

  static Future<bool> approveOrNot(contractAddress, hash, bool status) async {
    SessionModel sessionData = SessionModel();
    if (kDebugMode) {
      print(contractAddress);
    }
    SmartContractModel smartContractViewModel = SmartContractModel(
        contractAddress: contractAddress,
        abiName: 'Campaign',
        abiFileRoot: 'assets/abi_campaign.json',
        provider: sessionData.getProvider());
    if (status) {
      if (kDebugMode) {
        print("try to validate");
      }
      dynamic res = await smartContractViewModel.queryTransaction(
          'validateFile', [hash], null);
      if (res.toString() != "null" &&
          res.toString() != "0x0000000000000000000000000000000000000000") {
        return true;
      }
      return false;
    } else {
      if (kDebugMode) {
        print("try to not validate");
      }
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
