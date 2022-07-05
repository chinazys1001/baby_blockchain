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
  static Future<void> addTransaction(tr.Transaction transaction) async {
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
}
