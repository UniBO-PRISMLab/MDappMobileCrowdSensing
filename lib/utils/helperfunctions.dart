import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/crypto.dart';

String truncateString(String text, int front, int end) {
  int size = front + end;

  if (text.length > size) {
    String finalString =
        "${text.substring(0, front)}...${text.substring(text.length - end)}";
    return finalString;
  }

  return text;
}

String generateSessionMessage(String accountAddress) {
  String message =
      'Hello $accountAddress, the session is created.';
  print(message);
  var hash = keccakUtf8(message);
  final hashString = '0x${bytesToHex(hash).toString()}';
  return hashString;
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/light.txt');
}

Future<String> readCounter() async {
  try {
    final File file = await localFile;
    final contents = await file.readAsString();
    return contents;
  } catch (e) {
    return "ERROR: $e";
  }
}

Future<File> writeLightRelevation(String content) async {
  final file = await localFile;
  return file.writeAsString(content);
}