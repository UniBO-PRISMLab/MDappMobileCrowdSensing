class NonceManager {
  static int nonce = 1;

  static int getNonce() {
    try {
      return nonce;
    } finally {
      print("assigned nonce: $nonce");
      nonce ++;
    }
  }
}