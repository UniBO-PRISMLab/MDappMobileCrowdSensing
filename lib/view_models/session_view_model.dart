import 'package:web3dart/web3dart.dart';

import '../models/session_model.dart';

class SessionViewModel {
  SessionModel _sessionModel = SessionModel();

  Web3Client getEthClient() {
    return _sessionModel.ethClient;
  }

  dynamic getAccountPrivateKey() {
    return getSession().accounts[0];
  }

  dynamic getConnector(){
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