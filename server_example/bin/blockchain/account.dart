import 'dart:typed_data';

import 'blockchain.dart';
import 'key_pair.dart';
import 'operation.dart';
import 'robot.dart';
import 'signature.dart';

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
    await blockchain!.robotDatabase.addAccount(accountID);

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
    bool accountIsValid =
        await blockchain!.robotDatabase.accountExists(accountID);
    if (!accountIsValid) return false; // returning null if not

    // getting robots from robotDatabase. robots from mempool are not included
    Set<Robot> robots = await blockchain!.robotDatabase.getRobots(
      accountID,
      includeMempool: false,
    );

    verifiedAccount = Account(
      accountID: accountID,
      keyPair: keyPair,
      robots: robots,
    );

    return true;
  }

  /// Adds the given robot to the account.
  /// If `updateDB` is false, account does not get updated in [RobotDatabase].
  Future<void> addRobot(Robot robot, {bool updateDB = true}) async {
    // ensuring that the given robot doesn't belong to the account
    if (robots.contains(robot)) {
      throw ArgumentError(
        "The Robot is already present in the set of robots",
        robot.toString(),
      );
    }
    try {
      // adding a robot in robotDatabase
      if (updateDB) await blockchain!.robotDatabase.addRobot(robot);
      // updating current state
      robots.add(robot);
    } catch (e) {
      rethrow;
    }
  }

  /// Removes the given robot from the account.
  /// If `updateDB` is false, account does not get updated in [RobotDatabase].
  Future<void> removeRobot(Robot robot, {bool updateDB = true}) async {
    // ensuring that the given robot belongs to the account
    if (!robots.contains(robot)) {
      throw ArgumentError("The Robot is abscent in {robots}", robot.toString());
    }
    try {
      // removing a robot from robotDatabase
      if (updateDB) await blockchain!.robotDatabase.removeRobot(robot);
      // updating current state
      robots.remove(robot);
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
  Operation createOperation(String receiverID, String robotID) {
    // sender = current account
    Account sender = Account(
      accountID: accountID,
      keyPair: keyPair,
      robots: robots,
    );
    Operation operation = Operation.createOperation(
      sender,
      receiverID,
      robotID,
    );
    return operation;
  }

  /// Updates set of owned robots with the actual value from `robotDatabase`.
  Future<void> updateAccountRobots() async {
    robots = await blockchain!.robotDatabase.getRobots(
      accountID,
      includeMempool: false,
    );
  }

  /// Returns all confirmed operations, which were performed by the account.
  Future<List<Operation>> getPendingOperations() async {
    return await blockchain!.mempool.getAccountOperations(accountID);
  }

  /// Returns all confirmed operations, which were performed by the account.
  Future<List<Operation>> getConfirmedOperations() async {
    return await blockchain!.txDatabase.getAccountOperations(accountID);
  }

  // equivalent of printBalance()
  /// Testing-only
  void printRobots() {
    print("Robots: ${robots.toString()}");
  }

  /// Testing-only
  void printAccount() {
    print("------------------------Account------------------------");
    print("Account ID: $accountID");
    print("Key Pair: ${keyPair.toString()}");
    print("Robots: ${robots.toString()}");
    print("-------------------------------------------------------");
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
