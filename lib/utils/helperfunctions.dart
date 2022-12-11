import 'dart:async';
import 'dart:io';
import 'package:flutter_config/flutter_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/crypto.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

Future<String> get temporaryDirectoryPath async {
  final directory = await getTemporaryDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/light.txt');
}

Future<File> get temporaryFile async {
  final path = await temporaryDirectoryPath;
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

Future<String> uploadIPFS(File file) async {
  String username = FlutterConfig.get('INFURA_PROJECT_ID');
  String password = FlutterConfig.get('INFURA_API_SECRET');

  String basicAuth = 'Basic ${base64.encode(utf8.encode("$username:$password"))}';
  var stream = http.ByteStream(file.openRead());
  var length = await file.length();
  var url = Uri.https('ipfs.infura.io:5001','/api/v0/add');
  var request = http.MultipartRequest("POST", url);
  request.headers['Authorization'] = basicAuth;
  var multipartFile = http.MultipartFile('file', stream, length, filename: basename(file.path));
  request.files.add(multipartFile);
  var response = await request.send();
  var result = await http.Response.fromStream(response);
  var jsonResponse = jsonDecode(result.body);
  print('IPFS-HASH: ${jsonResponse['Hash']}');
  return jsonResponse['Hash'];
}

Future<String> getOnlyHashIPFS(File file) async {
  String username = FlutterConfig.get('INFURA_PROJECT_ID');
  String password = FlutterConfig.get('INFURA_API_SECRET');

  String basicAuth = 'Basic ${base64.encode(utf8.encode("$username:$password"))}';
  var stream = http.ByteStream(file.openRead());
  var length = await file.length();
  var url = Uri.https('ipfs.infura.io:5001','/api/v0/add',{'only-hash':'true'});
  var request = http.MultipartRequest("POST", url);
  request.headers['Authorization'] = basicAuth;
  var multipartFile = http.MultipartFile('file', stream, length, filename: basename(file.path));
  request.files.add(multipartFile);
  var response = await request.send();
  var result = await http.Response.fromStream(response);
  var jsonResponse = jsonDecode(result.body);
  print('PRE-IPFS-HASH: ${jsonResponse['Hash']}');
  return jsonResponse['Hash'];
}

Future<String> downloadItemIPFS(String hash,String localFolder) async {
  String username = FlutterConfig.get('INFURA_PROJECT_ID');
  String password = FlutterConfig.get('INFURA_API_SECRET');
  String basicAuth = 'Basic ${base64.encode(utf8.encode("$username:$password"))}';
  print("DEBUG::::::::::::::::::::::::::::::::::::::::::::::::::::::::::[downloadItemIPFS] temporaryDirectoryPath: $temporaryDirectoryPath");
  Directory dir = await Directory("$temporaryDirectoryPath/$localFolder/").create();
  var url = Uri.https('ipfs.infura.io:5001','/api/v0/get',{'arg':hash,'output': dir.path});
  var request = http.MultipartRequest("POST", url);
  request.headers['Authorization'] = basicAuth;
  var response = await request.send();
  var result = await http.Response.fromStream(response);
  var jsonResponse = jsonDecode(result.body);
  print('downloadItemIPFS: ${jsonResponse.toString()}');
  return jsonResponse[0];
}

List<FileSystemEntity> getDownloadedFiles(String folder) {
  Directory dir = Directory("temporaryDirectoryPath/$folder");
  return dir.listSync();
}