import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';

import 'hash.dart';
import 'key_pair.dart';

/// Custom implementation of [Signature] class. Usage description can be found in README.
/// [Signature] uses private key to sign
class Signature extends KeyPair {
  Signature({required super.privateKey, required super.publicKey});

  // input: map(stands for operation to be signed), KeyPair(only privateKey is used)
  // output: signature(list of bytes)
  /// Create the signature of the given string using the private key associated with the given [KeyPair]
  static Uint8List signData(String data, KeyPair keyPair) {
    // getting hash of the given data
    String hashedData = Hash.toSHA256(data);
    // splitting the hash value into bytes
    Uint8List hashedDataBytes = utf8.encode(hashedData) as Uint8List;
    Uint8List signatureBytes =
        keyPair.privateKey.createSHA256Signature(hashedDataBytes);

    return signatureBytes;
  }

  /// Verifying the signature of the given string signed with the given public key.
  static bool verifySignature(
      Uint8List signature, String data, String publicKeyString) {
    // getting hash of the given data
    String hashedData = Hash.toSHA256(data);
    // splitting the hash value into bytes
    Uint8List hashedDataBytes = utf8.encode(hashedData) as Uint8List;
    // verifying
    ECPublicKey publicKey = ECPublicKey.fromString(publicKeyString);
    bool isValid = publicKey.verifySHA256Signature(hashedDataBytes, signature);
    return isValid;
  }
}
