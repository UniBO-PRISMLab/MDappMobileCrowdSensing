import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManagerModel {
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> get temporaryDirectoryPath async {
    final directory = await getTemporaryDirectory();
    print(
        "There are ${directory.listSync().length} files in the tmp directory");
    return directory.path;
  }

  static Future<void> clearTemporaryDirectory() async {
    final directory = await getTemporaryDirectory();
    directory.deleteSync(recursive: true);
  }

  static Future<File> get localFile async {
    final path = await localPath;
    return File('$path/light.txt');
  }

  static Future<String> readCounter() async {
    try {
      final File file = await localFile;
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "ERROR: $e";
    }
  }

  static Future<File> writeLightRelevation(String content) async {
    final file = await localFile;
    return file.writeAsString(content);
  }
}
