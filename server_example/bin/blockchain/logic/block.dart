import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';

import 'hash.dart';
import 'transaction.dart';

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
  final Set<Transaction> setOfTransactions;

  /// Timestamp of the block creation.
  final Timestamp timestamp;

  /// Creating block, which contains the given `setOfTransactions`, `prevHash` and
  /// current timestamp. Block ID is hash value of these values.
  static Block createBlock(
    Set<Transaction> setOfTransactions,
    String prevHash,
  ) {
    String blockID = Hash.toSHA256(prevHash + setOfTransactions.toString());
    return Block(
      blockID: blockID,
      prevHash: prevHash,
      setOfTransactions: setOfTransactions,
      timestamp: Timestamp.fromDateTime(DateTime.now()),
    );
  }

  /// Testing-only
  void printBlock() {
    print("-------------------------Block-------------------------");
    print("Block ID: $blockID");
    print("Previous Hash: $prevHash");
    print("Nonce: ${setOfTransactions.toString()}");
    print("Timestamp: ${timestamp.toDateTime().toString()}");
    print("-------------------------------------------------------");
  }

  @override
  String toString() {
    Map<String, dynamic> mapTransaction = {
      "blockID": blockID,
      "prevHash": prevHash,
      "setOfTransactions": setOfTransactions.toString(),
      "timestamp": timestamp.toDateTime().toString(),
    };
    return mapTransaction.toString();
  }
}
