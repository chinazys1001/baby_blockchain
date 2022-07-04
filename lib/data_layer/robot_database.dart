import 'dart:math';

import 'package:baby_blockchain/data_layer/account_database.dart';
import 'package:baby_blockchain/domain_layer/hash.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ID of each DB document -> ID of corresponding robot.
/// Each document has three fields:
/// `owner` -> ID of master-account;
/// `name` -> name of a robot with corresponding ID;
/// `isTestMode` -> true if the robot was generated as an instance for testing.
class RobotDatabase {
  /// Generates and adds a document with id = sha256(ownerId + ownerNonce)  to [RobotDatabase]
  /// and updates `robotIDs` field of an account with given `ownerID` in [AccountDatabase]
  /// Account with given `ownerID` becomes the owner of the robot.
  static Future<void> addRobot(String ownerID,
      [String? robotName, bool isTestMode = false]) async {
    try {
      // since ownerID is unique and nonce of the account with ownerID increments
      // on each transactio received/sent from the account,
      // robotID = (ownerID + nonce) seems to be unique => its hash is unique as well
      int nonce = await AccountDatabase.getNonce(ownerID);
      await AccountDatabase.incrementNonce(ownerID); // incrementing nonce
      String robotID = Hash.toSHA256(ownerID + nonce.toString());

      // generating a random name for the robot
      if (robotName == null) {
        int randInd = Random.secure().nextInt(16);
        robotName = testRobotNames[randInd];
        // checking for namesakes
        await FirebaseFirestore.instance
            .collection("robotDatabase")
            .where("owner", isEqualTo: ownerID)
            .where("name", isGreaterThanOrEqualTo: robotName)
            .where("name", isLessThanOrEqualTo: '$robotName\uf8ff')
            .get()
            .then((docs) {
          if (docs.size > 0) {
            robotName = '${robotName!}(${docs.size + 1})';
          }
        });
      }

      // adding robot to robotDatabase
      await FirebaseFirestore.instance
          .collection("robotDatabase")
          .doc(
              robotID) // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          .set({
        "owner": ownerID,
        "name": robotName,
        "isTestMode": isTestMode,
      });

      await FirebaseFirestore.instance
          .collection("accountDatabase")
          .doc(
            ownerID.replaceAll('/',
                '-'), // FirebaseFirestore restricts using '/' in doc id => replacing '/' with '-'
          )
          .update({
        "robotIDs": FieldValue.arrayUnion([robotID]),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Returns instance of [Robot] with given `robotID`. If there is none, returns null.
  static Future<Robot> getRobotByID(String robotID) async {
    try {
      String name = "";
      String owner = "";
      bool isTestMode = false;
      await FirebaseFirestore.instance
          .collection("robotDatabase")
          .doc(robotID)
          .get()
          .then((doc) {
        name = doc.get("name");
        owner = doc.get("owner");
        isTestMode = doc.get("isTestMode");
      });
      return Robot(
        id: robotID,
        name: name,
        owner: owner,
        isTestMode: isTestMode,
      );
    } catch (e) {
      rethrow;
    }
  }
}
