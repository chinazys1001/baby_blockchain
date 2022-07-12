import 'package:firedart/firedart.dart';

import '../logic/transaction.dart'; // and here. Adding prefix "as tr" to manage conflicts.

/// Transactions Database
/// ID of each DB document -> ID of corresponding transaction.
/// Each document has two fields:
/// `operations` -> array of operations;
/// `nonce` -> nonce of transaction.
class TXDatabase {
  /// Adds given transaction to [TXDatabase].
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await Firestore.instance
          .collection("txDatabase")
          .document(transaction
              .transactionID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "operation": transaction.operation,
        "nonce": transaction.nonce,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> transactionExists(Transaction transaction) async {
    bool exists = false;
    await Firestore.instance
        .collection("txDatabase")
        .document(transaction.transactionID)
        .exists
        .then((value) => exists = value);
    return exists;
  }

  /// Testing-only
  Future<String> txDatabaseToString() async {
    String res = "";
    await Firestore.instance.collection("txDatabase").get().then((collection) {
      for (Document doc in collection) {
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
