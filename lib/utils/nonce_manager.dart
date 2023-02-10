import 'package:flutter/foundation.dart';

class NonceManager {
  static int nonce = 1;

  static int getNonce() {
    try {
      return nonce;
    } finally {
      if (kDebugMode) {
        print("assigned nonce: $nonce");
      }
      nonce ++;
    }
  }
}