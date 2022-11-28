import 'package:flutter_config/flutter_config.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class SessionModel {
  static final SessionModel _instance = SessionModel._internal();

  dynamic session, uri, signature;
  late WalletConnect  connector;

  late http.Client httpClient;
  late Web3Client ethClient;

  SessionModel._internal() {
    httpClient = http.Client();
    ethClient = Web3Client(FlutterConfig.get('ADDRESS_BLOCK_CHAIN'), http.Client());

    connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
            name: 'Mobile Crowd Sensing App',
            description: 'An app for collect data with crowds',
            url: 'https://walletconnect.org',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]));
  }

  factory SessionModel() {
    return _instance;
  }
}
