import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

import '../models/session_model.dart';

class SessionViewModel {
  final SessionModel _sessionModel = SessionModel();

  Web3Client getEthClient() {
    return _sessionModel.ethClient;
  }

  EthereumWalletConnectProvider getProvider(){
   return EthereumWalletConnectProvider(getConnector());
  }

  dynamic getAccountAddress() {
    return getSession().accounts[0];
  }

  WalletConnect getConnector(){
    return _sessionModel.connector;
  }

  dynamic getUri(){
    return _sessionModel.uri;
  }

  void setUri(uri){
     _sessionModel.uri = uri;
  }

  dynamic getSession(){
    return _sessionModel.session;
  }

  void setSession(session) {
    _sessionModel.session = session;
  }

  dynamic getSignature() {
    return _sessionModel.signature;
  }

  void setSignature(signature) {
    _sessionModel.signature = signature;
  }

  Future<void> checkConnection() async {
    SessionStorage? sessionStorage = getConnector().sessionStorage;
    if (sessionStorage != null) {
        setSession(sessionStorage.getSession());
        reconnect();
    } else {
      await sessionStorage?.store(getConnector().session);
    }
    getConnector().on('connect', (session) => {print('\x1B[31m[checkConnection]\x1B[0m:connect'),reconnect(),setSession(session)});
    getConnector().on('session_update', (payload) =>{print('\x1B[31m[checkConnection]\x1B[0m:session_update'), setSession(payload)});
    getConnector().on('disconnect', (payload) => {print('\x1B[31m[checkConnection]\x1B[0m:disconnect'),setSession(null), closeConnection()});
  }

  void reconnect(){
    print('\x1B[31m[Connection reconnected]\x1B[0m:connect');
    getConnector().reconnect();
  }
  void closeConnection() {
    print('\x1B[31m[Reconnect]\x1B[0m:connect');
    getConnector().close();
  }
  void killConnection(){
    print('\x1B[31m[Connection Killed]\x1B[0m:connect');
    getConnector().killSession();
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