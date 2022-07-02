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

  /// The number of transactions sent by the seller account of the operation.
  final int nonce;

  /// Creating transaction, which contains the given operation.
  static Transaction createTransaction(Operation operation) {
    // TODO: get nonce from accountDatabase
    int nonce = 1234;

    String transactionID = Hash.toSHA256(operation.toString());

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
