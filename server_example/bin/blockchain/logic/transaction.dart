import 'dart:convert';

import 'blockchain.dart';
import 'hash.dart';
import 'operation.dart';

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
  // account nonce - total number of times `robotIDs` length of account increased
  // (which means that nonce gets incremented on every single try of selling a robot)
  // => nonce is unique for every transaction executed by corresponding account
  final int nonce;

  /// Creating transaction, which contains the given operation.
  static Future<Transaction> createTransaction(Operation operation) async {
    int nonce = await blockchain.robotDatabase.getNonce(operation.senderID);

    String transactionID =
        Hash.toSHA256(operation.toString() + nonce.toString());

    blockchain.txDatabase.addTransaction(
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

  /// Testing-only
  void printTransaction() {
    print("----------------------Transaction----------------------");
    print("Transaction ID: $transactionID");
    print("Nonce: ${nonce.toString()}");
    print("Operation: ${operation.toString()}");
    print("-------------------------------------------------------");
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionID: json['transactionID'] as String,
      nonce: json['nonce'] as int,
      operation: Operation.fromJson(json['operation']),
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
