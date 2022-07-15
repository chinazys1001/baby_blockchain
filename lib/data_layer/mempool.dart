import 'package:baby_blockchain/domain_layer/operation.dart';
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

  /// Returns `true` if the transaction in present in [Mempool].
  Future<bool> transactionExists(tr.Transaction transaction) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  /// Returns set of all transactions stored currently in [Mempool].
  Future<Set<tr.Transaction>> getMempool() async {
    try {
      Set<tr.Transaction> pendingTransactions = {};
      await FirebaseFirestore.instance
          .collection("mempool")
          .get()
          .then((collection) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in collection.docs) {
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
    } catch (e) {
      rethrow;
    }
  }

  /// Returns all operations from [Mempool], where `senderID` is
  /// equal to the given `accountID`.
  Future<List<Operation>> getAccountOperations(String accountID) async {
    try {
      List<Operation> operations = [];
      await FirebaseFirestore.instance
          .collection("mempool")
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

  /// Returns stream of operations from [Mempool], where `senderID` is
  /// equal to the given `accountID`.
  Stream<List<Operation>> getAccountOperationsStream(String accountID) {
    try {
      return FirebaseFirestore.instance
          .collection("mempool")
          .where(
            "operation.senderID",
            isEqualTo: accountID.replaceAll('/', '-'),
          ) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map(
          (doc) {
            Map<String, dynamic> operationData = doc.get("operation");
            operationData["senderID"] =
                operationData["senderID"].toString().replaceAll('/', '-');
            operationData["receiverID"] =
                operationData["receiverID"].toString().replaceAll('/', '-');
            return Operation.fromJSON(operationData);
          },
        ).toList();
      });
    } catch (e) {
      rethrow;
    }
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
