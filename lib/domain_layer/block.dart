import 'package:baby_blockchain/domain_layer/transaction.dart'
    as tr; // Transaction class is defined both here
import 'package:cloud_firestore/cloud_firestore.dart'; // and here. Adding prefix "as tr" to manage conflicts.
import 'package:baby_blockchain/domain_layer/hash.dart';
import 'package:flutter/foundation.dart';

/// Custom implementation of [Block] class. Usage description can be found in README.
class Block {
  Block({
    required this.blockID,
    required this.prevHash,
    required this.setOfTransactions,
    required this.timestamp,
  });

  /// Unique Id of a [Block] is equal to the hash value of `prevHash` and `setOfTransactions`.
  final String blockID;

  /// `blockID` of the previous block.
  final String prevHash;

  /// Set of [Transaction]s to be included in the [Block].
  final Set<tr.Transaction> setOfTransactions;

  /// Timestamp of the block creation.
  final Timestamp timestamp;

  /// Creating block, which contains the given `setOfTransactions`, `prevHash` and
  /// current timestamp. Block ID is hash value of these values.
  static Block createBlock(
    Set<tr.Transaction> setOfTransactions,
    String prevHash,
  ) {
    String blockID = Hash.toSHA256(prevHash + setOfTransactions.toString());
    return Block(
      blockID: blockID,
      prevHash: prevHash,
      setOfTransactions: setOfTransactions,
      timestamp: Timestamp.now(),
    );
  }

  /// Testing-only
  void printBlock() {
    if (kDebugMode) {
      print("-------------------------Block-------------------------");
      print("Block ID: $blockID");
      print("Previous Hash: $prevHash");
      print("Nonce: ${setOfTransactions.toString()}");
      print("Timestamp: ${timestamp.toDate().toString()}");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapTransaction = {
      "blockID": blockID,
      "prevHash": prevHash,
      "setOfTransactions": setOfTransactions.toString(),
      "timestamp": timestamp.toDate().toString(),
    };
    return mapTransaction.toString();
  }
}
