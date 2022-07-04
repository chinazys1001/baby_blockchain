import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_blockchain/domain_layer/account.dart';

/// ID of each DB document -> ID of corresponding account.
/// Each document has two fields:
/// `robotIDs` -> set of IDs of robots, owned by this account;
/// `nonce` -> total number of times `robotIDs` length of account changed;
/// (which means that `nonce` gets incremented on every single "purchase"/"sale").
class AccountDatabase {
  /// Adds a document with given `accountID` to [AccountDatabase].
  static Future<void> addAccount(String accountID, Set<String> robotIDs) async {
    try {
      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(accountID.replaceAll('/',
              '-')) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "robotIDs": robotIDs,
        "nonce": 0,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if a document with given `accountID` is present in [AccountDatabase]
  static Future<bool> accountExists(String accountID) async {
    try {
      bool exists = false;
      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(accountID.replaceAll('/', '-'))
          .get()
          .then((doc) {
        exists = doc.exists;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  /// Returns set of robots, owned by [Account] with given `accountID`
  static Future<Set<String>> getRobotIDs(String accountID) async {
    try {
      Set<String> robotIDs = {};
      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(accountID.replaceAll('/', '-'))
          .get()
          .then((doc) {
        robotIDs = Set<String>.from(doc.get("robotIDs"));
      });
      return robotIDs;
    } catch (e) {
      rethrow;
    }
  }

  /// Returns `nonce` corresponding to [Account] with given `accountID`
  static Future<int> getNonce(String accountID) async {
    try {
      int nonce = 0;
      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(accountID.replaceAll('/', '-'))
          .get()
          .then((doc) {
        nonce = doc.get("nonce");
      });
      return nonce;
    } catch (e) {
      rethrow;
    }
  }

  /// Do call it every time length of [Account] `robotIDs` gets changed
  static Future<void> incrementNonce(String accountID) async {
    try {
      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(accountID.replaceAll('/', '-'))
          .update({
        "nonce": FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }
}
