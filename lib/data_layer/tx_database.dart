import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:baby_blockchain/domain_layer/transaction.dart'
    as tr; // Transaction class is defined both here
import 'package:cloud_firestore/cloud_firestore.dart'; // and here. Adding prefix "as tr" to manage conflicts.

/// Transactions Database stores all transaxctions ever added to blockchain.
/// ID of each DB document -> ID of corresponding transaction.
/// Each document has two fields:
/// `nonce` -> nonce of transaction.
/// `operations` -> array of operations;
class TXDatabase {
  /// Adds given transaction to [TXDatabase].
  Future<void> addTransaction(tr.Transaction transaction) async {
    try {
      await FirebaseFirestore.instance
          .collection("txDatabase")
          .doc(transaction.transactionID)
          .set({
        "nonce": transaction.nonce,
        "operation": transaction.operation.toJSON(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> transactionExists(tr.Transaction transaction) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  /// Returns all operations from [TXDatabase], where `senderID` is
  /// equal to the given `accountID`.
  Future<List<Operation>> getAccountOperations(String accountID) async {
    try {
      List<Operation> operations = [];
      await FirebaseFirestore.instance
          .collection("txDatabase")
          .where(
            "operation.senderID",
            isEqualTo: accountID.replaceAll('/', '-'),
          ) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .get()
          .then((collection) {
        for (var doc in collection.docs) {
          Map<String, dynamic> operationData = doc.get("operation");
          operationData["senderID"] =
              operationData["senderID"].toString().replaceAll('/', '-');
          operationData["receiverID"] =
              operationData["receiverID"].toString().replaceAll('/', '-');
          operations.add(Operation.fromJSON(operationData));
        }
      });
      return operations;
    } catch (e) {
      rethrow;
    }
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
