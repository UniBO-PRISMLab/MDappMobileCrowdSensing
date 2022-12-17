import 'package:mobile_crowd_sensing/models/file_manager_model.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:tar/tar.dart';
import 'dart:async';
import 'dart:io';

class IpfsClientModel {

  static Future<String> uploadIPFS(File file) async {
    String username = FlutterConfig.get('INFURA_PROJECT_ID');
    String password = FlutterConfig.get('INFURA_API_SECRET');

    String fileContent = await file.readAsString();
    print("FILE that i try to upload: $fileContent");
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
    //print('IPFS-HASH: ${jsonResponse['Hash']}');
    return jsonResponse['Hash'];
  }

  static Future<String> getOnlyHashIPFS(File file) async {
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

  static Future<String?> downloadItemIPFS(String hash,String localFolder) async {
    String username = FlutterConfig.get('INFURA_PROJECT_ID');
    String password = FlutterConfig.get('INFURA_API_SECRET');
    String basicAuth = 'Basic ${base64.encode(utf8.encode("$username:$password"))}';
    String tmpPath = await FileManagerModel.temporaryDirectoryPath;
    Directory('$tmpPath/$localFolder/').create();
    var list = List<int>.generate(100, (i) => i)..shuffle();
    List<int> names = list.take(5).toList();
    String name = '';
    for (int i = 0; i<names.length; i++) {
      name += names[i].toString();
    }
    var url = Uri.https('ipfs.infura.io:5001','/api/v0/get',{'arg':hash ,'output': '$tmpPath/$localFolder/'});
    var request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = basicAuth;
    StreamedResponse response = await request.send();
    var result = await http.Response.fromStream(response);

    if (result.statusCode == 200) {
      File file = await File("$tmpPath/$localFolder/$name").writeAsBytes(result.bodyBytes);
      TarReader reader = TarReader(file.openRead());
      while (await reader.moveNext()) {
        final entry = reader.current;
        return await entry.contents.transform(utf8.decoder).first;
      }
    }
    return null;
  }
}
