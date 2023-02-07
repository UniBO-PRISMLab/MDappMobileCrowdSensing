import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import 'db_session_model.dart';

class SessionModel {

  static final SessionModel _instance = SessionModel._internal();

  late dynamic uri, signature;
  late WalletConnect  connector;
  late http.Client httpClient;
  late Web3Client ethClient;
  late EthereumWalletConnectProvider provider;
  final DbSessionModel dbSession = DbSessionModel();

  factory SessionModel() {
    return _instance;
  }

  Future<EthereumWalletConnectProvider> _initSession() async {
    httpClient = http.Client();
    ethClient = Web3Client(FlutterConfig.get('ADDRESS_BLOCK_CHAIN'), httpClient);
    connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
            name: 'Mobile Crowd Sensing App',
            description: 'An app for collect data with crowds',
            url: 'https://walletconnect.org',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]
        )
    );
    provider = EthereumWalletConnectProvider(connector);

    connector.on('connect', (session) => {
      print('\x1B[31m[checkConnection ON]\x1B[0m:connect'),
      reconnect()
    });
    connector.on('session_update', (WCSessionUpdateResponse payload) async => {
      print('\x1B[31m[checkConnection ON]\x1B[0m:session_update'),
      connector.updateSession(SessionStatus(chainId: payload.chainId, accounts: payload.accounts)),
      await dbSession.updateSession(Session(account: payload.accounts[0], chainId: payload.chainId))
    });
    connector.on('disconnect', (payload) => {
      print('\x1B[31m[checkConnection ON]\x1B[0m:disconnect'),
      closeConnection()
    });

    
    connector.registerListeners(
        onConnect: (SessionStatus payload) {
          print('\x1B[31m[checkConnection]\x1B[0m:connect');
          connector.session.accounts = payload.accounts;
          connector.session.chainId = payload.chainId;
        },
        onSessionUpdate: (WCSessionUpdateResponse res) async {
          print('\x1B[31m[checkConnection]\x1B[0m:session_update');
          connector.session.chainId = res.chainId;
          connector.session.accounts = res.accounts;
          await dbSession.updateSession(Session(account: res.accounts[0], chainId: res.chainId));
        },
        onDisconnect: () async {
          print('\x1B[31m[checkConnection]\x1B[0m:disconnect');
          await dbSession.deleteAll();
        }
    );
    return provider;
  }

  SessionModel._internal() {
    _initSession();
  }

  EthereumWalletConnectProvider getProvider(){
   return provider;
  }

  dynamic getAccountAddress() {
    return connector.session.accounts[0];
  }

 /* Future<void> checkConnection() async {
    connector.on('connect', (session) => {
      print('\x1B[31m[checkConnection]\x1B[0m:connect'),
      reconnect()
    });
    connector.on('session_update', (WCSessionUpdateResponse payload) async => {
      print('\x1B[31m[checkConnection]\x1B[0m:session_update'),
      connector.updateSession(SessionStatus(chainId: payload.chainId, accounts: payload.accounts)),
      await dbSession.updateSession(Session(account: payload.accounts[0], chainId: payload.chainId))
    });
    connector.on('disconnect', (payload) => {
      print('\x1B[31m[checkConnection]\x1B[0m:disconnect'),
      closeConnection()
    });
  }*/

  void reconnect(){
    print('\x1B[31m[Connection reconnected]\x1B[0m:connect');
    connector.reconnect();
  }
  void closeConnection() {
    print('\x1B[31m[Reconnect]\x1B[0m:connect');
    connector.close();
  }
  void killConnection(){
    print('\x1B[31m[Connection Killed]\x1B[0m:connect');
    connector.killSession();
  }
  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 80001:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Chain';
    }
  }
}