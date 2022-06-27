import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:baby_blockchain/domain_layer/key_pair.dart';

/// Custom implementation of [Signature] class. Usage description can be found in README.
/// [Signature] uses private key to sign
class Signature extends KeyPair {
  Signature({required super.privateKey, required super.publicKey});

  // input: map(stands for operation to be signed), KeyPair(only privateKey is used)
  // output: signature(list of bytes)
  /// Create the signature of a SHA256-hashed data using the associated [KeyPair] private key
  static Uint8List signData(String data, KeyPair keyPair) {
    Uint8List operationBytes = utf8.encode(data) as Uint8List;
    Uint8List signatureBytes =
        keyPair.privateKey.createSHA256Signature(operationBytes);

    return signatureBytes;
  }

  /// Verify the signature of a SHA256-hashed operation signed with the associated [KeyPair] private key
  static bool verifySignature(
      Uint8List signature, String operation, KeyPair keyPair) {
    Uint8List operationBytes = utf8.encode(operation) as Uint8List;
    bool isValid =
        keyPair.publicKey.verifySHA256Signature(operationBytes, signature);
    return isValid;
  }
}
