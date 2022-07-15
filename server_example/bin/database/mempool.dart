import 'package:firedart/firedart.dart';

import '../blockchain/operation.dart';
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

  /// Returns `true` if the transaction is present in [Mempool].
  Future<bool> transactionExists(Transaction transaction) async {
    try {
      bool exists = false;
      await Firestore.instance.collection("mempool").get().then((collection) {
        for (Document document in collection) {
          if (document.id == transaction.transactionID) {
            exists = true;
            break;
          }
        }
      });
      return exists;
    } catch (e) {
      rethrow;
    }
  }

  /// Returns set of all transactions stored currently in [Mempool].
  Future<Set<Transaction>> getMempool() async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  /// Returns all operations from [Mempool], where `senderID` is
  /// equal to the given `accountID`.
  Future<List<Operation>> getAccountOperations(String accountID) async {
    try {
      List<Operation> operations = [];
      await Firestore.instance
          .collection("mempool")
          .where(
            "operation.senderID",
            isEqualTo: accountID.replaceAll('/', '-'),
          ) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .get()
          .then((collection) {
        for (var doc in collection) {
          Map<String, dynamic> operationData = doc.map["operation"];
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
