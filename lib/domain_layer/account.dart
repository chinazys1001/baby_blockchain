import 'dart:typed_data';

import 'package:baby_blockchain/data_layer/robot_database.dart';
import 'package:baby_blockchain/domain_layer/key_pair.dart';
import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/domain_layer/signature.dart';
import 'package:flutter/foundation.dart';

/// Account user successfully signed-in to
Account? verifiedAccount;

/// Custom implementation of [Account] class. Usage description can be found in README.
class Account {
  Account({
    required this.accountID,
    required this.keyPair,
    required this.robots,
  });

  /// Account ID <=> public key of its key pair.
  final String accountID;

  /// Each account has exactly one key pair. See README for further info.
  final KeyPair keyPair;

  /// [Set] of [Robot]s, which which are owned by this account.
  Set<Robot> robots;

  /// Generating account: assigning its key pair, id(public key) and ownership list(empty)
  static Future<Account> genAccount() async {
    // since each account has one and only immutable key pair,
    // this key pair gets associated with its account in initial account creation
    // hence smth like addKeyPairToWallet() func from the ref is not needed
    // as smth like well as getBalance() - you can access list of robots,
    // owned by specified account by a default getter
    KeyPair keyPair = KeyPair.genKeyPair();
    String accountID = keyPair.publicKey.toString();
    Set<Robot> robots = {};

    // adding the account to RobotDatabase.
    await RobotDatabase.addAccount(accountID);

    return Account(
      accountID: accountID,
      keyPair: keyPair,
      robots: robots,
    );
  }

  /// Returns true if an account corresponding to the given privateKey exists in [RobotDatabase]
  /// and stores the account in global variable `verifiedAccount`.
  /// If an account with the given privateKey is absent in [RobotDatabase], returns false.
  static Future<bool> tryToSignInToAccount(String privateKeyBase64) async {
    // getting corresponding instance of KeyPair
    KeyPair? keyPair = KeyPair.getKeyPairFromPrivateKey(privateKeyBase64);
    // returning null if the fromat of provided private key is invalid
    if (keyPair == null) return false;
    // id <=> publicKey
    String accountID = keyPair.publicKey.toString();

    // checking if the account exists
    bool accountIsValid = await RobotDatabase.accountExists(accountID);
    if (!accountIsValid) return false; // returning null if not

    // getting robots from accountDatabase
    Set<Robot> robots = await RobotDatabase.getRobots(accountID);

    verifiedAccount = Account(
      accountID: accountID,
      keyPair: keyPair,
      robots: robots,
    );

    return true;
  }

  /// Since the account user signed in is stored globally in `verifiedAccount`,
  /// it can be checked if the `verifiedAccount` ID is equal to the given `account`.
  /// If so, return [Account] instance, equal to `verifiedAccount`.
  /// If not => user hasn't signed in to the account with given ID, return null.
  static Account? tryToGetAccountByID(String accountID) {
    if (verifiedAccount == null) return null;
    if (accountID != verifiedAccount!.accountID) return null;

    return Account(
      accountID: verifiedAccount!.accountID,
      keyPair: verifiedAccount!.keyPair,
      robots: verifiedAccount!.robots,
    );
  }

  /// Adds the given robot to the corresponding account in [RobotDatabase].
  Future<void> addRobot(Robot robot) async {
    // ensuring that robot with given `robotID` doesn't belong to the account
    if (robots.contains(robot)) {
      throw ArgumentError(
        "The Robot is already present in the set of robots",
        robot.toString(),
      );
    }
    try {
      // adding a robot in robotDatabase
      await RobotDatabase.addRobot(robot);
    } catch (e) {
      rethrow;
    }
  }

  /// Removes the given robot from the corresponding account in [RobotDatabase].
  Future<void> removeRobot(Robot robot) async {
    // ensuring that robotID belongs to the account
    if (!robots.contains(robot)) {
      throw ArgumentError("The Robot is abscent in robotIDs", robot.toString());
    }
    try {
      // removing a robot from robotDatabase
      await RobotDatabase.removeRobot(robot);
    } catch (e) {
      rethrow;
    }
  }

  /// [Signature.signData] method is used to create a signature with this [Account].
  Uint8List signData(String data) {
    Uint8List signature = Signature.signData(data, keyPair);
    return signature;
  }

  /// [Operation.createOperation] method is used to create an operation from this [Account].
  Operation createOperation(Account buyer, String robotID) {
    // seller = current account
    Account seller = Account(
      accountID: accountID,
      keyPair: keyPair,
      robots: robots,
    );
    Operation operation = Operation.createOperation(
      seller,
      buyer,
      robotID,
    );
    return operation;
  }

  // equivalent of printBalance()
  /// Testing-only
  void printRobots() {
    if (kDebugMode) {
      print("Robots: ${robots.toString()}");
    }
  }

  /// Testing-only
  void printAccount() {
    if (kDebugMode) {
      print("------------------------Account------------------------");
      print("Account ID: $accountID");
      print("Key Pair: ${keyPair.toString()}");
      print("Robots: ${robots.toString()}");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapAccount = {
      "accountID": accountID,
      "keyPair": keyPair.toString(),
      "robots": robots.toString(),
    };
    return mapAccount.toString();
  }

  /// Two accounts are considered to be equal if their IDs match.
  @override
  bool operator ==(covariant Account other) => other.accountID == accountID;
  @override
  int get hashCode => accountID.hashCode;
}
