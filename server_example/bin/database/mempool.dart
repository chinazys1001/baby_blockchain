import 'package:firedart/firedart.dart';

import '../blockchain/transaction.dart';

/// Mempool stores all pending transactions.
/// ID of each DB document -> ID of corresponding transaction.
/// Each document has two fields:
/// `nonce` -> nonce of transaction.
/// `operations` -> array of operations;
class Mempool {
  /// Adds given transaction to [Mempool].
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await Firestore.instance
          .collection("mempool")
          .document(transaction.transactionID)
          .set({
        "nonce": transaction.nonce,
        "operation": transaction.operation.toJSON(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Removes given transaction from [Mempool].
  Future<void> removeTransaction(Transaction transaction) async {
    try {
      await Firestore.instance
          .collection("mempool")
          .document(transaction.transactionID)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> transactionExists(Transaction transaction) async {
    bool exists = false;
    await Firestore.instance
        .collection("mempool")
        .document(
          transaction.transactionID,
        )
        .exists
        .then((value) => exists = value);
    return exists;
  }

  /// Returns set of all transactions stored currently in [Mempool].
  Future<Set<Transaction>> getMempool() async {
    Set<Transaction> pendingTransactions = {};
    await Firestore.instance.collection("mempool").get().then((collection) {
      for (Document doc in collection) {
        if (doc.id == "placeholder") continue;
        Transaction transaction = Transaction.fromJSON({
          "transactionID": doc.id,
          "nonce": doc.map["nonce"],
          "operation": doc.map["operation"],
        });
        pendingTransactions.add(transaction);
      }
    });
    return pendingTransactions;
  }

  /// Testing-only
  Future<String> mempoolToString() async {
    String res = "";
    await Firestore.instance.collection("mempool").get().then((collection) {
      for (Document doc in collection) {
        if (doc.id == "placeholder") continue;
        Map<String, dynamic> mapDoc = {
          "transactionID": doc.id,
          "nonce": doc.map["nonce"],
          "operations": doc.map["operations"],
        };
        res += '$mapDoc\n';
      }
    });
    return res;
  }
}
