import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileManagerModel {

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> get temporaryDirectoryPath async {
    final directory = await getTemporaryDirectory();
    if (kDebugMode) {
      print(
        "There are ${directory.listSync().length} files in the tmp directory");
    }
    return directory.path;
  }

  static Future<void> clearTemporaryDirectory() async {
    final directory = await getTemporaryDirectory();
    directory.deleteSync(recursive: true);
  }


  static Future<File> get localLightFile async {
    final path = await localPath;
    return File('$path/light.txt');
  }

  static Future<File> writeLightInLocalLightFile(String content) async {
    final file = await localLightFile;
    return file.writeAsString(content);
  }

  static Future<Directory> writePhotosInLocalFile(List<File> photos) async {
    final path = await localPath;
    final dir = Directory('$path/photos');
    if(await dir.exists()) {
      for (File p in photos) {
        File("${dir.path}/$p");
      }
    }
    return dir;
  }


}
