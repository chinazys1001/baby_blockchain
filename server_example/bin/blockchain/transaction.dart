import 'dart:convert';

import '../database/robot_database.dart';
import 'account.dart';
import 'blockchain.dart';
import 'hash.dart';
import 'operation.dart';
import 'robot.dart';

/// Custom implementation of [Transaction] class. Usage description can be found in README.
class Transaction {
  Transaction({
    required this.transactionID,
    required this.operation,
    required this.nonce,
  });

  /// Hash value of all transaction fields.
  final String transactionID;

  /// In our case, each transation consists of a single operation. See README for explanation.
  final Operation operation;

  /// Nonce of the sender's account. Stored in [RobotDatabase].
  // account nonce - total number of times `robotIDs` length of account decreased
  // (which means that nonce gets incremented on every single try of selling a robot)
  // => nonce is unique for every transaction executed by corresponding account
  final int nonce;

  /// Creating transaction, which contains the given operation.
  static Future<Transaction> createTransaction(Operation operation) async {
    int nonce = await blockchain!.robotDatabase.getNonce(operation.senderID);

    String transactionID =
        Hash.toSHA256(operation.toString() + nonce.toString());

    blockchain!.txDatabase.addTransaction(
      Transaction(
        transactionID: transactionID,
        operation: operation,
        nonce: nonce,
      ),
    );

    return Transaction(
      transactionID: transactionID,
      operation: operation,
      nonce: nonce,
    );
  }

  /// Adds the given transaction in mempool and increments sender's nonce.
  static Future<void> addTransactionToMempool(Transaction transaction) async {
    // incrementing nonce of the sender account
    // on every attempt to add transaction to mempool
    await blockchain!.robotDatabase.incrementNonce(
      transaction.operation.senderID,
    );

    // adding the given transaction to mempool
    await blockchain!.mempool.addTransaction(transaction);
  }

  /// Executes the operation of the given `transaction`:
  /// - `robot` of the operation gets transferred from `sender` account to `buyer` account.
  /// - `robotDatabase` is updated with corresponding changes.
  /// - `transaction` is added to `txDatabase`.
  /// - sender's `nonce` gets incremented
  static Future<void> executeVerifiedTransaction(
    Transaction transaction,
  ) async {
    String robotID = transaction.operation.robotID;
    String senderID = transaction.operation.senderID;
    String receiverID = transaction.operation.receiverID;

    // getting robot from sender's robots by ID
    Set<Robot> senderRobots =
        await blockchain!.robotDatabase.getRobots(senderID);
    Robot robot = senderRobots
        .firstWhere((senderRobot) => senderRobot.robotID == robotID);

    // removing the robot from the set of sender's robots
    await blockchain!.robotDatabase.removeRobot(robot);

    // updating robot's ownerID with receiverID
    robot.ownerID = receiverID;
    // updating robot's name if needed
    robot.robotName = await Robot.getUniqueName(robot.robotName, robot.ownerID);

    // adding the robot to the set of owner's robots
    await blockchain!.robotDatabase.addRobot(robot);

    // adding the transaction to txDatabase
    await blockchain!.txDatabase.addTransaction(transaction);
  }

  /// Testing-only
  void printTransaction() {
    print("----------------------Transaction----------------------");
    print("Transaction ID: $transactionID");
    print("Nonce: ${nonce.toString()}");
    print("Operation: ${operation.toString()}");
    print("-------------------------------------------------------");
  }

  factory Transaction.fromJSON(Map<String, dynamic> json) {
    return Transaction(
      transactionID: json['transactionID'] as String,
      nonce: json['nonce'] as int,
      operation: Operation.fromJSON(json['operation']),
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {
      "transactionID": transactionID,
      "nonce": nonce,
      "operation": operation.toJSON(),
    };
    return json;
  }

  String toJSONString() {
    String jsonString = jsonEncode(<String, dynamic>{
      "transactionID": transactionID,
      "nonce": nonce,
      "operation": operation.toJSON(),
    });
    return jsonString;
  }

  @override
  String toString() {
    Map<String, dynamic> mapTransaction = {
      "transactionID": transactionID,
      "nonce": nonce.toString(),
      "operation": operation.toString(),
    };
    return mapTransaction.toString();
  }
}
