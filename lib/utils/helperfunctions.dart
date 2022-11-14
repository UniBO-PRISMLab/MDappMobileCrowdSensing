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