import 'package:baby_blockchain/data_layer/account_database.dart';
import 'package:baby_blockchain/data_layer/tx_database.dart';
import 'package:baby_blockchain/domain_layer/hash.dart';
import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:flutter/foundation.dart';

/// Custom implementation of [Transaction] class. Usage description can be found in README.
class Transaction {
  Transaction({
    required this.id,
    required this.operation,
    required this.nonce,
  });

  /// Hash value of all transaction fields.
  final String id;

  /// In our case, each transation consists of a single operation. See README for explanation.
  final Operation operation;

  /// Nonce of the seller's account. Stored in [AccountDatabase].
  // account nonce - total number of times `robotIDs` length of account changed
  // (which means that nonce gets incremented on every single "purchase"/"sale" try)
  // => nonce is unique for every transaction executed by corresponding account
  final int nonce;

  /// Creating transaction, which contains the given operation.
  static Future<Transaction> createTransaction(Operation operation) async {
    int nonce = await AccountDatabase.getNonce(operation.seller.id);

    String id = Hash.toSHA256(operation.toString() + nonce.toString());

    TXDatabase.addTransaction(
      Transaction(
        id: id,
        operation: operation,
        nonce: nonce,
      ),
    );

    return Transaction(
      id: id,
      operation: operation,
      nonce: nonce,
    );
  }

  /// Testing-only
  void printAccount() {
    if (kDebugMode) {
      print("----------------------Transaction----------------------");
      print("Transaction ID: $id");
      print("Operation: ${operation.toString()}");
      print("Nonce: ${nonce.toString()}");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapTransaction = {
      "transactionID": id,
      "operation": operation.toString(),
      "nonce": nonce.toString(),
    };
    return mapTransaction.toString();
  }
}
