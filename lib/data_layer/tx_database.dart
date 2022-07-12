import 'package:baby_blockchain/domain_layer/transaction.dart'
    as tr; // Transaction class is defined both here
import 'package:cloud_firestore/cloud_firestore.dart'; // and here. Adding prefix "as tr" to manage conflicts.

/// Transactions Database
/// ID of each DB document -> ID of corresponding transaction.
/// Each document has two fields:
/// `operations` -> array of operations;
/// `nonce` -> nonce of transaction.
class TXDatabase {
  /// Adds given transaction to [TXDatabase].
  Future<void> addTransaction(tr.Transaction transaction) async {
    try {
      await FirebaseFirestore.instance
          .collection("txDatabase")
          .doc(transaction
              .transactionID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "operation": transaction.operation,
        "nonce": transaction.nonce,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> transactionExists(tr.Transaction transaction) async {
    bool exists = false;
    await FirebaseFirestore.instance
        .collection("txDatabase")
        .where(
          FieldPath.documentId,
          isEqualTo: transaction.transactionID,
        )
        .get()
        .then((collection) => exists = collection.docs.isEmpty);
    return exists;
  }

  /// Testing-only
  Future<String> txDatabaseToString() async {
    String res = "";
    await FirebaseFirestore.instance
        .collection("txDatabase")
        .get()
        .then((collection) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
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
