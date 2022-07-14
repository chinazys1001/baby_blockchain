import 'package:baby_blockchain/domain_layer/block.dart';
import 'package:baby_blockchain/domain_layer/transaction.dart'
    as tr; // Transaction class is defined both here
import 'package:cloud_firestore/cloud_firestore.dart'; // and here. Adding prefix "as tr" to manage conflicts.

/// Block History stores all blocks ever added to blockchain.
/// ID of each DB document -> ID of corresponding block.
/// Each document has two fields:
/// `prevHash` -> ID of the previous block;
/// `setOfTransactions` -> transactions of corresponding block.
/// `height` -> height of the block
class BlockHistory {
  /// Adds given `block` to [BlockHistory].
  Future<void> addBlock(Block block) async {
    try {
      List<Map> setOfTransactions = [];
      for (tr.Transaction transaction in block.setOfTransactions) {
        setOfTransactions.add(transaction.toJSON());
      }

      await FirebaseFirestore.instance
          .collection("blockHistory")
          .doc(block
              .blockID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "prevHash": block.prevHash,
        "setOfTransactions": setOfTransactions,
        "height": block.height,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Block> getTopBlock() async {
    try {
      late Block block;
      await FirebaseFirestore.instance
          .collection("blockHistory")
          .orderBy("height", descending: true)
          .limit(1)
          .get()
          .then((collection) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc = collection.docs.first;
        Set<tr.Transaction> setOfTransactions = {};
        for (Map<String, dynamic> transactionJSON in doc["setOfTransactions"]) {
          setOfTransactions.add(tr.Transaction.fromJSON(transactionJSON));
        }
        block = Block(
          blockID: doc.id,
          prevHash: doc["prevHash"],
          setOfTransactions: setOfTransactions,
          height: doc["height"],
        );
      });
      return block;
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
          "height": doc.get("height"),
        };
        res += '$mapDoc\n';
      }
    });
    return res;
  }
}
