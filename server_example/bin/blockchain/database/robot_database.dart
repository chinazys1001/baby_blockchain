import 'package:firedart/firedart.dart';

import '../logic/robot.dart';

/// ID of each DB document -> ID of corresponding account.
/// Each document has two fields:
/// `robots` -> [Set] of [Robot]s, owned by this account
/// (each [Robot] is defined as a map of its attributes)
/// `nonce` -> total number of times `robots` length of account increased;
/// (which means that `nonce` gets incremented on every single "sale" attempt).
class RobotDatabase {
  /// Adds a document with given `accountID` to [RobotDatabase].
  /// Initially, `robots` list is blank. Nonce equals to zero.
  Future<void> addAccount(String accountID) async {
    try {
      await Firestore.instance
          .collection("robotDatabase")
          .document(accountID.replaceAll('/',
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
  Future<bool> accountExists(String accountID) async {
    try {
      bool exists = false;
      await Firestore.instance
          .collection("robotDatabase")
          .document(accountID.replaceAll('/', '-'))
          .exists
          .then((value) {
        exists = value;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  /// Returns [Set] of [Robot]s (`robots` field) from the document with given `accountID`.
  Future<Set<Robot>> getRobots(String accountID) async {
    try {
      Set<Robot> robots = {};
      await Firestore.instance
          .collection("robotDatabase")
          .document(accountID.replaceAll('/', '-'))
          .get()
          .then((doc) {
        List<dynamic> robotsList = doc.map["robots"];
        robots = Set<Robot>.from(Robot.fromList(robotsList));
      });
      return Set<Robot>.from(robots);
    } catch (e) {
      rethrow;
    }
  }

  /// Returns `nonce` corresponding to [Account] with given `accountID`
  Future<int> getNonce(String accountID) async {
    try {
      int nonce = 0;
      await Firestore.instance
          .collection("robotDatabase")
          .document(accountID.replaceAll('/', '-'))
          .get()
          .then((doc) {
        nonce = doc.map["nonce"];
      });
      return nonce;
    } catch (e) {
      rethrow;
    }
  }

  /// Increments `nonce`. Do call it every time length of [Account] `robots` gets increased.
  Future<void> incrementNonce(String accountID) async {
    try {
      int curNonce = 0;
      await Firestore.instance
          .collection("robotDatabase")
          .document(accountID.replaceAll('/', '-'))
          .get()
          .then((doc) => curNonce = doc.map["nonce"]);
      await Firestore.instance
          .collection("robotDatabase")
          .document(accountID.replaceAll('/', '-'))
          .update({
        "nonce": curNonce + 1,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Adds the given [Robot] to the [Account] corresponding to the given `robot.ownerID`.
  Future<void> addRobot(Robot robot) async {
    try {
      List<dynamic> curRobots = [];
      await Firestore.instance
          .collection("robotDatabase")
          .document(robot.ownerID.replaceAll('/', '-'))
          .get()
          .then((doc) => curRobots = doc.map["robots"]);
      curRobots.add(robot.toMap());

      // adding robot to robotDatabase
      await Firestore.instance
          .collection("robotDatabase")
          .document(robot
              .ownerID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .update({
        "robots": curRobots,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Removes the given [Robot] from the [Account] corresponding to the given `robot.ownerID`.
  Future<void> removeRobot(Robot robot) async {
    try {
      List<dynamic> curRobots = [];
      await Firestore.instance
          .collection("robotDatabase")
          .document(robot.ownerID.replaceAll('/', '-'))
          .get()
          .then((doc) => curRobots = doc.map["robots"]);
      curRobots.remove(robot.toMap());

      // adding robot to robotDatabase
      await Firestore.instance
          .collection("robotDatabase")
          .document(robot.ownerID.replaceAll('/',
              '-')) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .update({
        "robots": curRobots,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Testing-only
  Future<String> robotDatabaseToString() async {
    String res = "";
    await Firestore.instance
        .collection("robotDatabase")
        .get()
        .then((collection) {
      for (Document doc in collection) {
        Map<String, dynamic> mapDoc = {
          "accountID": doc.id,
          "nonce": doc.map["nonce"],
          "robots": doc.map["robots"],
        };
        res += '$mapDoc\n';
      }
    });
    return res;
  }
}
