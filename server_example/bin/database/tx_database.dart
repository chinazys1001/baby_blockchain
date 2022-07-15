import 'package:firedart/firedart.dart';

import '../blockchain/operation.dart';
import '../blockchain/transaction.dart'; // and here. Adding prefix "as tr" to manage conflicts.

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
          .document(transaction.transactionID)
          .set({
        "operation": transaction.operation.toJSON(),
        "nonce": transaction.nonce,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Returns `true` if the transaction is present in [TXDatabase].
  Future<bool> transactionExists(Transaction transaction) async {
    try {
      bool exists = false;
      await Firestore.instance
          .collection("txDatabase")
          .get()
          .then((collection) {
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

  /// Returns all operations from [TXDatabase], where `senderID` is
  /// equal to the given `accountID`.
  Future<List<Operation>> getAccountOperations(String accountID) async {
    try {
      List<Operation> operations = [];
      await Firestore.instance
          .collection("txDatabase")
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
