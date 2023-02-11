import 'package:flutter/foundation.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import '../services/services_controller.dart';
import 'db_capaign_model.dart';
import 'db_session_model.dart';

class SessionModel {

  static final SessionModel _instance = SessionModel._internal();

  late dynamic uri, signature;
  late WalletConnect?  connector;
  late http.Client httpClient;
  late Web3Client ethClient;
  late EthereumWalletConnectProvider provider;
  final DbSessionModel dbSession = DbSessionModel();
  late WalletConnectSecureStorage sessionStorage;

  factory SessionModel() {
    return _instance;
  }

   _initSession() {
    sessionStorage = WalletConnectSecureStorage();
    httpClient = http.Client();
    ethClient = Web3Client(FlutterConfig.get('ADDRESS_BLOCK_CHAIN'), httpClient);

    instantiateConnector();
  }

  Future<void> instantiateConnector() async {
    WalletConnectSession? session = await sessionStorage.getSession();
    if(session == null) {
      if (kDebugMode) {
        print('\x1B[31m[SESSION MODEL] session null:${session.toString()} \x1B[0m');
      }
      connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        sessionStorage: sessionStorage,
        clientMeta: const PeerMeta(
            name: 'Mobile Crowd Sensing App',
            description: 'An app for collect data with crowds',
            url: 'https://walletconnect.org',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]
        ),
      );
    } else {
      if (kDebugMode) {
        print('\x1B[31m[SESSION MODEL] session:${session.toString()} \x1B[0m');
      }
      await sessionStorage.store(session);
      connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        session: session,
        sessionStorage: sessionStorage,
        clientMeta: const PeerMeta(
            name: 'Mobile Crowd Sensing App',
            description: 'An app for collect data with crowds',
            url: 'https://walletconnect.org',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]
        ),
      );
      await connector!.connect(
          onDisplayUri: (newUri) async {
            uri = newUri;
          });
    }

    await dbSession.deleteAll();
    await dbSession.insertSession(Session(account: connector!.session.accounts[0], chainId: connector!.session.chainId, uri: uri));
    DbCampaignModel dbCampaign = DbCampaignModel();
    List<Campaign> listCamapigns = await dbCampaign.campaigns();
    if(listCamapigns.isNotEmpty) {
      if (kDebugMode) {
        print('\x1B[31m [CLOSED CAMPAIGN SERVICE] INITIALIZE AFTER LOGIN\x1B[0m');
      }
      ServicesController.initializeBackgroundService();
    }

    provider = EthereumWalletConnectProvider(connector!);

    connector!.registerListeners(
        onDisconnect: () {
          if (kDebugMode) {
            print('\x1B[31m[EVENT DISCONNECT] \x1B[0m');
          }
          connector!.killSession();
          connector = null;
          ethClient.dispose();
        },
        onConnect: (SessionStatus session){
          if (kDebugMode) {
            print('\x1B[31m[EVENT CONNECT] session:${session.toString()} \x1B[0m');
          }
          connector!.session.accounts = session.accounts;
          connector!.session.chainId = session.chainId;
        },
        onSessionUpdate: (WCSessionUpdateResponse payload) async {
          if (kDebugMode) {
            print('\x1B[31m[EVENT UPDATE] payload:${payload.toString()} \x1B[0m');
          }
          connector!.session.chainId = payload.chainId;
          connector!.session.accounts = payload.accounts;
          await dbSession.updateSession(Session(account: payload.accounts[0], chainId: payload.chainId, uri: uri));
        }
    );
  }


  SessionModel._internal() {
    _initSession();
  }


  EthereumWalletConnectProvider getProvider(){
   return provider;
  }

  dynamic getAccountAddress() {
    if (connector == null) {
      instantiateConnector();
    }
    return connector!.session.accounts[0];
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