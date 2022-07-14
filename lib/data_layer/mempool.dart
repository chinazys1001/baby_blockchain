import 'package:baby_blockchain/domain_layer/transaction.dart'
    as tr; // Transaction class is defined both here
import 'package:cloud_firestore/cloud_firestore.dart'; // and here. Adding prefix "as tr" to manage conflicts.

/// Mempool stores all pending transactions.
/// ID of each DB document -> ID of corresponding transaction.
/// Each document has two fields:
/// `nonce` -> nonce of transaction.
/// `operations` -> array of operations;
class Mempool {
  /// Adds given transaction to [Mempool].
  Future<void> addTransaction(tr.Transaction transaction) async {
    try {
      await FirebaseFirestore.instance
          .collection("mempool")
          .doc(transaction.transactionID)
          .set({
        "nonce": transaction.nonce,
        "operation": transaction.operation.toJSON(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Removes given transaction from [Mempool].
  Future<void> removeTransaction(tr.Transaction transaction) async {
    try {
      await FirebaseFirestore.instance
          .collection("mempool")
          .doc(transaction.transactionID)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> transactionExists(tr.Transaction transaction) async {
    bool exists = false;
    await FirebaseFirestore.instance
        .collection("mempool")
        .where(
          FieldPath.documentId,
          isEqualTo: transaction.transactionID,
        )
        .get()
        .then((collection) => exists = collection.docs.isEmpty);
    return exists;
  }

  /// Returns set of all transactions stored currently in [Mempool].
  Future<Set<tr.Transaction>> getMempool() async {
    Set<tr.Transaction> pendingTransactions = {};
    await FirebaseFirestore.instance
        .collection("mempool")
        .get()
        .then((collection) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
        if (doc.id == "placeholder") continue;
        tr.Transaction transaction = tr.Transaction.fromJSON({
          "transactionID": doc.id,
          "nonce": doc.get("nonce"),
          "operation": doc.get("operation"),
        });
        pendingTransactions.add(transaction);
      }
    });
    return pendingTransactions;
  }

  /// Testing-only
  Future<String> mempoolToString() async {
    String res = "";
    await FirebaseFirestore.instance
        .collection("mempool")
        .get()
        .then((collection) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
        if (doc.id == "placeholder") continue;
        Map<String, dynamic> mapDoc = {
          "transactionID": doc.id,
          "nonce": doc.get("nonce"),
          "operations": doc.get("operations"),
        };
        res += '$mapDoc\n';
      }
    });
    return res;
  }
}
