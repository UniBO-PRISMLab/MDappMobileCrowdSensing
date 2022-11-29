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

upload(File imageFile) async {
  String username = FlutterConfig.get('INFURA_PROJECT_ID');
  String password = FlutterConfig.get('INFURA_API_SECRET');

  String basicAuth = 'Basic ${base64.encode(utf8.encode("$username:$password"))}';
  var stream = http.ByteStream(imageFile.openRead());
  var length = await imageFile.length();
  var url = Uri.https('ipfs.infura.io:5001','/api/v0/add');
  var request = http.MultipartRequest("POST", url);
  request.headers['Authorization'] = basicAuth;
  var multipartFile = http.MultipartFile('file', stream, length, filename: basename(imageFile.path));
  request.files.add(multipartFile);
  var response = await request.send();
  print('STATUS REQUEST: ${response.statusCode}');

  response.stream.transform(utf8.decoder).listen((value) {
    var jsonResponse = jsonDecode(value);
    print('HASH: ${jsonResponse['Hash']}');
  });
}

//uploadNotWorking() {
  // final Map body = {'file': '$path/light.txt'};
  //
  // var url = Uri.https(
  //     'ipfs.infura.io:5001',
  //     '/api/v0/add'
  // );
  // print(url);
  // var response = await http.post(
  //   url,
  //   body: json.encode(body),
  //     headers: <String, String>{
  //      "Authorization": basicAuth,
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     }
  // );
  // print('REQUEST: ${response.request}');
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
//}