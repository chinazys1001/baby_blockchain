import 'package:flutter/foundation.dart';
import 'package:crypton/crypton.dart';

late KeyPair currentKeyPair; // the generated value is stored here

class KeyPair {
  static late ECPublicKey _publicKey;
  // underscore stands for private modifier in dart
  static late ECPrivateKey _privateKey;

  set publicKey(newValue) => _publicKey = newValue;
  ECPublicKey get publicKey => _publicKey;

  // since privateKey is a private modifier, protected get method should be used
  // to transmit the value to the subclasses(e.g. Signature class)
  @protected
  set privateKey(newValue) => _privateKey = newValue;
  @protected
  ECPrivateKey get privateKey => _privateKey;

  // randomly generating elliptic curve key pair
  static KeyPair genKeyPair() {
    KeyPair keyPair = KeyPair();

    ECKeypair ecKeypair = ECKeypair.fromRandom();
    keyPair.publicKey = ecKeypair.publicKey;
    keyPair.privateKey = ecKeypair.privateKey;

    return keyPair;
  }

  void printKeyPair() {
    if (kDebugMode) {
      print("Public key: ${_publicKey.toString()}");
    }
    if (kDebugMode) {
      print("Private key: ${_privateKey.toString()}");
    }
  }
}
