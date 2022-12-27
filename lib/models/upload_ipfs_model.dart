import 'package:mobile_crowd_sensing/models/file_manager_model.dart';
import 'package:mobile_crowd_sensing/models/search_places_model.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'package:flutter/foundation.dart';
import 'ipfs_client_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';


class UploadIpfsModel {
  static Future<bool> uploadLight(List<double>? lights,
      double averageRelevation, String contractAddress) async {
    SessionModel sessionData = SessionModel();
    await FileManagerModel.writeLightInLocalLightFile(
        "${DateTime.now().millisecondsSinceEpoch}/${averageRelevation.toString()}");
    try {
      SmartContractModel smartContractViewModel = SmartContractModel(
          contractAddress, 'Campaign', 'assets/abi_campaign.json',
          provider: sessionData.getProvider());
      SearchPlacesModel position = SearchPlacesModel();
      await position.updateLocalPosition();
      String preHash = await IpfsClientModel.getOnlyHashIPFS(
          await FileManagerModel.localLightFile);
      List<dynamic> args = [
        preHash,
        BigInt.from((position.lat * 10000000).round()),
        BigInt.from((position.lng * 10000000).round())
      ];
      String value = await smartContractViewModel.queryTransaction(
          'uploadFile', args, null);
      if (value != "null" &&
          value != '0x0000000000000000000000000000000000000000') {
        IpfsClientModel.uploadIPFS(await FileManagerModel.localLightFile);
        return true;
      }
      if (kDebugMode) {
        print(
            '\x1B[31m [DEBUG]:::::::::::::::::::::::::: [uploadLight]$value\x1B[0m');
      }
      return false;
    } catch (error) {
      return false;
    }
  }


  static Future<bool> uploadPhotos(List<File> photos, String contractAddress) async {
    try {
      SessionModel sessionData = SessionModel();
      Directory dir = await FileManagerModel.writePhotosInLocalFile(photos);
      SmartContractModel smartContractViewModel = SmartContractModel(
          contractAddress, 'Campaign', 'assets/abi_campaign.json',
          provider: sessionData.getProvider());
      SearchPlacesModel position = SearchPlacesModel();
      await position.updateLocalPosition();
      String preHash = await IpfsClientModel.getOnlyHashIPFSDirectory(photos);
      print("Si può FARE!:::::: $preHash");
      List<dynamic> args = [
        preHash,
        BigInt.from((position.lat * 10000000).round()),
        BigInt.from((position.lng * 10000000).round())
      ];
      String value = "null";//await smartContractViewModel.queryTransaction('uploadFile', args, null);
      if (value != "null" &&
          value != '0x0000000000000000000000000000000000000000') {
        //IpfsClientModel.uploadMultipleFileIPFS(dir);
        return true;
      }
      if (kDebugMode) {
        print(
            '\x1B[31m [DEBUG]:::::::::::::::::::::::::: [uploadPhotos]$value\x1B[0m');
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}
