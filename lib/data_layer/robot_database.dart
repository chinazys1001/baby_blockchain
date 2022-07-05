import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ID of each DB document -> ID of corresponding account.
/// Each document has two fields:
/// `robots` -> [Set] of [Robot]s, owned by this account
/// (each [Robot] is defined as a map of its attributes)
/// `nonce` -> total number of times `robots` length of account increased;
/// (which means that `nonce` gets incremented on every single "sale" attempt).
class RobotDatabase {
  /// Adds a document with given `accountID` to [RobotDatabase].
  /// Initially, `robots` list is blank. Nonce equals to zero.
  static Future<void> addAccount(String accountID) async {
    try {
      await FirebaseFirestore.instance
          .collection("robotDatabase")
          .doc(accountID.replaceAll('/',
              '-')) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "robots": Set.of(<Robot>{}),
        "nonce": 0,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if a document with given `accountID` is present in [RobotDatabase].
  static Future<bool> accountExists(String accountID) async {
    try {
      bool exists = false;
      await FirebaseFirestore.instance
          .collection("robotDatabase")
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

  /// Returns [Set] of [Robot]s (`robots` field) from the document with given `accountID`.
  static Future<Set<Robot>> getRobots(String accountID) async {
    try {
      Set<Robot> robots = {};
      await FirebaseFirestore.instance
          .collection("robotDatabase")
          .doc(accountID.replaceAll('/', '-'))
          .get()
          .then((doc) {
        List<dynamic> robotsList = doc.get("robots");
        robots = Set<Robot>.from(Robot.fromList(robotsList));
      });
      return Set<Robot>.from(robots);
    } catch (e) {
      rethrow;
    }
  }

  /// Returns `nonce` corresponding to [Account] with given `accountID`
  static Future<int> getNonce(String accountID) async {
    try {
      int nonce = 0;
      await FirebaseFirestore.instance
          .collection("robotDatabase")
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

  /// Increments `nonce`. Do call it every time length of [Account] `robots` gets increased.
  static Future<void> incrementNonce(String accountID) async {
    try {
      await FirebaseFirestore.instance
          .collection("robotDatabase")
          .doc(accountID.replaceAll('/', '-'))
          .update({
        "nonce": FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Adds the given [Robot] to the [Account] corresponding to the given `robot.ownerID`.
  static Future<void> addRobot(Robot robot) async {
    try {
      // adding robot to robotDatabase
      await FirebaseFirestore.instance
          .collection("robotDatabase")
          .doc(robot
              .ownerID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .update({
        "robots": FieldValue.arrayUnion([robot.toMap()]),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Removes the given [Robot] from the [Account] corresponding to the given `robot.ownerID`.
  static Future<void> removeRobot(Robot robot) async {
    try {
      // adding robot to robotDatabase
      await FirebaseFirestore.instance
          .collection("robotDatabase")
          .doc(robot
              .ownerID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .update({
        "robots": FieldValue.arrayRemove([robot.toMap()]),
      });
    } catch (e) {
      rethrow;
    }
  }
}
