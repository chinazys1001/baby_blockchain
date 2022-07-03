import 'package:cloud_firestore/cloud_firestore.dart';

/// ID of each DB document -> ID of corresponding account.
/// Each document has a single robotIDs field -> set of IDs of robots, owned by this account
class AccountDatabase {
  /// Adds a document with given accountID to [AccountDatabase].
  static Future<void> addAccount(String accountID, Set<String> robotIDS) async {
    try {
      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(accountID.replaceAll('/',
              '-')) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "robotIDs": robotIDS,
        "operations": 0,
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
          .doc(accountID.replaceAll('-', '/')) // swapping back
          .get()
          .then((doc) {
        exists = doc.exists;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  /// Checks if a document with given `accountID` is present in [AccountDatabase]
  static Future<Set<String>> getRobotIDs(String accountID) async {
    try {
      Set<String> robotIDs = {};
      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(accountID.replaceAll('-', '/')) // swapping back
          .get()
          .then((doc) {
        robotIDs = Set<String>.from(doc.get("robotIDs"));
      });
      return robotIDs;
    } catch (e) {
      rethrow;
    }
  }
}
