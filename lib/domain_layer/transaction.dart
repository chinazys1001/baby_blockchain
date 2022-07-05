import 'package:baby_blockchain/data_layer/robot_database.dart';
import 'package:baby_blockchain/data_layer/tx_database.dart';
import 'package:baby_blockchain/domain_layer/hash.dart';
import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:flutter/foundation.dart';

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

  /// Nonce of the seller's account. Stored in [RobotDatabase].
  // account nonce - total number of times `robotIDs` length of account increased
  // (which means that nonce gets incremented on every single try of selling a robot)
  // => nonce is unique for every transaction executed by corresponding account
  final int nonce;

  /// Creating transaction, which contains the given operation.
  static Future<Transaction> createTransaction(Operation operation) async {
    int nonce = await RobotDatabase.getNonce(operation.seller.accountID);

    String transactionID =
        Hash.toSHA256(operation.toString() + nonce.toString());

    TXDatabase.addTransaction(
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
  void printAccount() {
    if (kDebugMode) {
      print("----------------------Transaction----------------------");
      print("Transaction ID: $transactionID");
      print("Operation: ${operation.toString()}");
      print("Nonce: ${nonce.toString()}");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapTransaction = {
      "transactionID": transactionID,
      "operation": operation.toString(),
      "nonce": nonce.toString(),
    };
    return mapTransaction.toString();
  }
}
