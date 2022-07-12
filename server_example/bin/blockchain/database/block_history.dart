import 'package:firedart/firedart.dart';

import '../logic/block.dart';

/// Block History
/// ID of each DB document -> ID of corresponding block.
/// Each document has two fields:
/// `prevHash` -> ID of the previous block;
/// `setOfTransactions` -> transactions of corresponding block.
/// `timestamp` -> timestamp of block creation
class BlockHistory {
  /// Adds given `block` to [BlockHistory].
  Future<void> addBlock(Block block) async {
    try {
      await Firestore.instance
          .collection("blockHistory")
          .document(block
              .blockID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "prevHash": block.prevHash,
        "setOfTransactions": block.setOfTransactions,
        "timestamp": block.timestamp,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getTopBlockID() async {
    try {
      String blockID = "";
      await Firestore.instance
          .collection("blockHistory")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get()
          .then((collection) => blockID = collection[0]["blockID"]);
      return blockID;
    } catch (e) {
      rethrow;
    }
  }

  /// Testing-only
  Future<String> blockHistoryToString() async {
    String res = "";
    await Firestore.instance
        .collection("blockHistory")
        .get()
        .then((collection) {
      for (Document doc in collection) {
        Map<String, dynamic> mapDoc = {
          "blockID": doc.id,
          "prevHash": doc.map["prevHash"],
          "setOfTransactions": doc.map["setOfTransactions"],
          "timestamp": doc.map["timestamp"],
        };
        res += '$mapDoc\n';
      }
    });
    return res;
  }
}
