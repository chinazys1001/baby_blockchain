import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:baby_blockchain/domain_layer/key_pair.dart';
import 'package:flutter/foundation.dart';

// privateKey is a private modifier, hence Signature extends KeyPair to get access to privateKey
class Signature extends KeyPair {
  static late Uint8List _bytes; // signature value in bytes

  set bytes(newValue) => _bytes = newValue;
  Uint8List get bytes => _bytes;

  // input: map(stands for operation to be signed), KeyPair(only privateKey is used)
  // output: signature(list of bytes)
  static Signature signData(Map<String, int> operation, KeyPair keyPair) {
    Signature signature = Signature();

    Uint8List operationBytes = utf8.encode(operation.toString()) as Uint8List;
    Uint8List signatureBytes =
        keyPair.privateKey.createSHA256Signature(operationBytes);
    signature.bytes = signatureBytes;

    return signature;
  }

  static bool verifySignature(
      Signature signature, Map<String, int> operation, KeyPair keyPair) {
    Uint8List operationBytes = utf8.encode(operation.toString()) as Uint8List;
    bool isValid = keyPair.publicKey
        .verifySHA256Signature(operationBytes, signature.bytes);
    return isValid;
  }

  void printSignature() {
    if (kDebugMode) {
      print("Signature: ${bytes.toString()}");
    }
  }
}
