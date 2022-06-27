import 'dart:typed_data';

import 'package:baby_blockchain/domain_layer/key_pair.dart';
import 'package:baby_blockchain/domain_layer/signature.dart';
import 'package:flutter/foundation.dart';

/// Custom implementation of [Account] class. Usage description can be found in README.
class Account {
  Account({required this.id, required this.keyPair, required this.robotIDs});

  /// Account id <=> public key of its key pair.
  final String id;

  /// Each account has exactly one key pair. See README for further info.
  final KeyPair keyPair;

  /// Account "balance" is a list of robots IDs, which are owned by this account.
  /// Robot ID is some unique random string(thus two robots never have the same IDs and are stored in [Set]).
  final Set<String> robotIDs;

  /// Generating account: assigning its key pair, id(public key) and ownership list(empty)
  static Account genAccount() {
    // since each account has one and only immutable key pair,
    // this key pair gets associated with its account in initial account creation
    // hence smth like addKeyPairToWallet() func from the ref is not needed
    // as smth like well as getBalance() - you can access list of robots,
    // owned by specified account by a default getter
    KeyPair keyPair = KeyPair.genKeyPair();
    String id = keyPair.publicKey.toString();
    Set<String> robotIDs = {};

    return Account(
      id: id,
      keyPair: keyPair,
      robotIDs: robotIDs,
    );
  }

  // updateBalance() from the ref is divided here into two sub-methods:
  /// addRobot(String id) -> adding robot (its id) to the list of owned robots
  void addRobot(String robotID) {
    // ensuring that robotID doesn't belong to the account
    if (robotIDs.contains(robotID)) {
      throw ArgumentError("$robotID is already present in robotIDs", robotID);
    }
    robotIDs.add(robotID);
  }

  /// removeRobot(String id) -> remove robot (its id) from the list of owned robots
  void removeRobot(String robotID) {
    // ensuring that robotID belongs to the account
    if (!robotIDs.contains(robotID)) {
      throw ArgumentError("$robotID is abscent in robotIDs", robotID);
    }
    robotIDs.remove(robotID);
  }

  /// [Signature.signData] method is used to create a signature with account private key.
  Uint8List signData(String data) {
    Uint8List signature = Signature.signData(data, keyPair);
    return signature;
  }

  // TODO: createOperation().

  // equivalent of printBalance()
  // Testing-only
  void printRobots() {
    if (kDebugMode) {
      print("Robots: ${robotIDs.toString()}");
    }
  }

  // Testing-only
  void printAccount() {
    if (kDebugMode) {
      print("------------------------Account------------------------");
      print("Id: $id");
      print("Key Pair: ${keyPair.toString()}");
      print("Robots: ${robotIDs.toString()}");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapAccount = {
      "id": id,
      "key pair": keyPair.toString(),
      "ownership list": robotIDs.toString(),
    };
    return mapAccount.toString();
  }
}
