import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:crypton/crypton.dart';
import 'package:hex/hex.dart';

/// Custom implementation of [KeyPair] class. Usage description can be found in README.
/// See https://pub.dev/packages/crypton for implemetation of [ECKeypair].
class KeyPair {
  /// Value of [privateKey] can be used within [KeyPair] class and its subcalsses only
  KeyPair({required ECPrivateKey privateKey, required this.publicKey})
      : _privateKey = privateKey;

  /// Value of [publicKey].
  final ECPublicKey publicKey;

  final ECPrivateKey
      _privateKey; //underscore stands for private modifier in dart

  // since privateKey is a private modifier, protected get method should be used
  // to transmit the value to the subclasses(e.g. Signature class)
  @protected
  ECPrivateKey get privateKey => _privateKey;

  /// Randomly generating elliptic curve key pair.
  /// See https://pub.dev/packages/crypton for implemetation of [ECKeypair.fromRandom].
  static KeyPair genKeyPair() {
    ECKeypair ecKeypair = ECKeypair.fromRandom();
    return KeyPair(
      privateKey: ecKeypair.privateKey,
      publicKey: ecKeypair.publicKey,
    );
  }

  /// returns KeyPair corresponding to the given privateKey
  static KeyPair getKeyPairFromPrivateKey(String privateKeyBase64) {
    String privateKeyHex = HEX.encode(base64.decode(privateKeyBase64));
    ECPrivateKey privateKey = ECPrivateKey.fromString(privateKeyHex);
    ECPublicKey publicKey = privateKey.publicKey;
    return KeyPair(
      privateKey: privateKey,
      publicKey: publicKey,
    );
  }

  /// Testing only
  void printKeyPair() {
    if (kDebugMode) {
      print("------------------------Key Pair------------------------");
      print("Public key: ${publicKey.toString()}");
      print("Private key: ${_privateKey.toString()}");
      print("--------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapKeyPair = {
      "public key": publicKey,
      "private key": _privateKey,
    };
    return mapKeyPair.toString();
  }
}
