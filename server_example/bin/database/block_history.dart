import 'package:firedart/firedart.dart';

import '../blockchain/block.dart';
import '../blockchain/transaction.dart';

/// Block History
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
      for (Transaction transaction in block.setOfTransactions) {
        setOfTransactions.add(transaction.toJSON());
      }

      await Firestore.instance
          .collection("blockHistory")
          .document(block
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
      await Firestore.instance
          .collection("blockHistory")
          .orderBy("height", descending: true)
          .limit(1)
          .get()
          .then((collection) {
        Document doc = collection.first;
        Set<Transaction> setOfTransactions = {};
        for (Map<String, dynamic> transactionJSON
            in doc.map["setOfTransactions"]) {
          setOfTransactions.add(Transaction.fromJSON(transactionJSON));
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
    await Firestore.instance
        .collection("blockHistory")
        .get()
        .then((collection) {
      for (Document doc in collection) {
        Map<String, dynamic> mapDoc = {
          "blockID": doc.id,
          "prevHash": doc.map["prevHash"],
          "setOfTransactions": doc.map["setOfTransactions"],
          "height": doc.map["height"],
        };
        res += '$mapDoc\n';
      }
    });
    return res;
  }
}
