import 'package:baby_blockchain/domain_layer/block.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      await FirebaseFirestore.instance
          .collection("blockHistory")
          .doc(block
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
      await FirebaseFirestore.instance
          .collection("blockHistory")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get()
          .then((collection) => blockID = collection.docs[0]["blockID"]);
      return blockID;
    } catch (e) {
      rethrow;
    }
  }

  /// Testing-only
  Future<String> blockHistoryToString() async {
    String res = "";
    await FirebaseFirestore.instance
        .collection("blockHistory")
        .get()
        .then((collection) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
        Map<String, dynamic> mapDoc = {
          "blockID": doc.id,
          "prevHash": doc.get("prevHash"),
          "setOfTransactions": doc.get("setOfTransactions"),
          "timestamp": doc.get("timestamp"),
        };
        res += '$mapDoc\n';
      }
    });
    return res;
  }
}
