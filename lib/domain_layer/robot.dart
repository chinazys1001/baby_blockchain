import 'dart:math';
import 'dart:typed_data';

import 'package:baby_blockchain/data_layer/robot_database.dart';
import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/hash.dart';
import 'package:baby_blockchain/domain_layer/varificational_token.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/foundation.dart';

/// Basic instance of [Robot] class is defined with following objects:
/// `name` -> name of a robot with corresponding ID;
/// `id` -> unique robot identifier;
/// `owner` -> ID of master-account;
/// `isTestMode` -> true if the robot was generated as an instance for testing.
class Robot {
  const Robot({
    required this.robotID,
    required this.ownerID,
    required this.robotName,
    this.isTestMode = false,
  });

  final String robotID;
  final String ownerID;
  final String robotName;
  final bool isTestMode;

  /// Generates a [Robot] with unique `robotID` (among all accounts)
  /// and unique `robotName` (among the robots currently owned by the account with the given `ownerID`).
  /// `isTestMode` parameter is optional and should be set manually. Default value is False.
  static Future<Robot> generateRandomRobot({
    required String ownerID,
    bool isTestMode = true,
  }) async {
    // Step 1. Generating a unique 256-bit hex ID for the robot:

    // since ownerID is unique and nonce of the account with ownerID increments
    // on each transaction received/sent from the account,
    // robotID = (ownerID + nonce) seems to be unique => its hash is unique as well
    int nonce = await RobotDatabase.getNonce(ownerID);
    await RobotDatabase.incrementNonce(ownerID); // incrementing nonce
    String robotID = Hash.toSHA256(ownerID + nonce.toString());

    // Step 2. Generating a unique name among owner's robots:

    // getting random name from `randomRobotsNames`
    int randInd = Random.secure().nextInt(16);
    String robotName = randomRobotNames[randInd];
    // checking for "namesakes"
    int repeats = await RobotDatabase.getNumberOfNamesakes(robotName, ownerID);
    // e.g. if there are robots named Taras and Taras-2 among the robots owned
    // by the corresponding account and randomName = "Taras", then to avoid
    // repeats a suffix "-3" should be added
    if (repeats > 0) robotName += (repeats + 1).toString();

    return Robot(
      robotID: robotID,
      ownerID: ownerID,
      robotName: robotName,
      isTestMode: isTestMode,
    );
  }

  /// Just a code snippet for a method used to connect to the robot.
  /// Expected to return true if the robot approved the request.
  Future<bool> requestConnection() async {
    Account? owner = Account.tryToGetAccountByID(ownerID);
    if (owner == null) {
      throw Exception("Access to owner account denied");
    }
    Uint8List verificationalToken =
        VerificationalToken.generate(owner, robotID);

    if (isTestMode) {
      debugPrint("Generated token: ${verificationalToken.toString()}");
      return true;
    }

    // now the generated token can be send to the robot, for instance, via Bluetooth:
    /* pseudo code:
    await sendViaBluetooth(verificationalToken).then((response) {
      if (responce == true) {
        print("Party!");
        return true;
      }
      else {
        print("wtf[permission-denied]");
        return false;
      }
    });
    */

    return false; // unfortunately, the robot is not ready yet :)
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapRobot = {
      "robotID": robotID,
      "robotName": robotName,
      "ownerID": ownerID,
      "isTestMode": isTestMode,
    };
    return mapRobot;
  }

  /// Testing-only
  void printRobot() {
    if (kDebugMode) {
      print("-------------------------Robot-------------------------");
      print("Robot ID: $robotID");
      print("Robot name: $robotName");
      print("Owner ID: $ownerID");
      if (isTestMode) print("Mode: Test");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapRobot = {
      "robotID": robotID,
      "robotName": robotName,
      "ownerID": ownerID,
      "isTestMode": isTestMode,
    };
    return mapRobot.toString();
  }

  /// Two robots are considered to be equal if their IDs match.
  @override
  bool operator ==(covariant Robot other) => other.robotID == robotID;
  @override
  int get hashCode => robotID.hashCode;
}