import 'dart:convert';
import 'dart:typed_data';

import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/blockchain.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/domain_layer/signature.dart';
import 'package:flutter/foundation.dart';

/// Custom implementation of [Operation] class. Usage description can be found in README.
class Operation {
  Operation({
    required this.senderID,
    required this.receiverID,
    required this.robotID,
    required this.senderSignature,
  });

  /// Account that claims to own the robot.
  final String senderID;

  /// ID of an account the sender wants transfer ownership of the robot to.
  final String receiverID;

  /// ID of the robot to be "sold".
  final String robotID;

  // sender signs the operation.
  Uint8List senderSignature;

  /// Creating operation with given sender account, receiver account and robotID.
  static Operation createOperation(
      Account sender, String receiverID, String robotID) {
    if (sender.accountID == receiverID) {
      throw ArgumentError(
        "sender cannot be equal to receiver",
        sender.toString(),
      );
    }

    // operation data to be signed
    Map<String, dynamic> operationData = {
      "senderID": sender.accountID,
      "receiverID": receiverID,
      "robotID": robotID,
    };

    // sender signs hashed operation data
    Uint8List senderSignature =
        Signature.signData(operationData.toString(), sender.keyPair);

    return Operation(
      senderID: sender.accountID,
      receiverID: receiverID,
      robotID: robotID,
      senderSignature: senderSignature,
    );
  }

  /// Checking if both signature is correct and sender does own robot with given id
  static Future<bool> verifyOperation(Operation operation) async {
    if (operation.senderID == operation.receiverID) return false;

    // operation data that must have been signed
    Map<String, dynamic> operationData = {
      "senderID": operation.senderID,
      "receiverID": operation.receiverID,
      "robotID": operation.robotID,
    };

    // verifying signature of the data with sender's public key <=> sender's ID
    if (!Signature.verifySignature(operation.senderSignature,
        operationData.toString(), operation.senderID)) {
      return false;
    }

    // verifying if the sender owns robot with given robotID
    Set<Robot> senderRobots = await blockchain.robotDatabase.getRobots(
      operation.senderID,
    ); // getting sender's robots from db
    if (senderRobots
        .where((robot) => robot.robotID == operation.robotID)
        .isEmpty) {
      return false; // returning false if sender doesn't own the robot with corresponding robotID
    }

    return true;
  }

  /// Testing-only
  void printOperation() {
    if (kDebugMode) {
      print("-----------------------Operation-----------------------");
      print("sender: $senderID");
      print("receiver: $receiverID");
      print("Robot ID: $robotID");
      print("Signature: ${senderSignature.toString()}");
      print("-------------------------------------------------------");
    }
  }

  factory Operation.fromJSON(Map<String, dynamic> json) {
    return Operation(
      senderID: json['senderID'] as String,
      receiverID: json['receiverID'] as String,
      robotID: json['robotID'] as String,
      senderSignature: Uint8List.fromList(json['signature'].cast<int>()),
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {
      "senderID": senderID,
      "receiverID": receiverID,
      "robotID": robotID,
      "signature": senderSignature,
    };
    return json;
  }

  String toJSONString() {
    String jsonString = jsonEncode(<String, dynamic>{
      "senderID": senderID,
      "receiverID": receiverID,
      "robotID": robotID,
      "signature": senderSignature,
    });
    return jsonString;
  }

  @override
  String toString() {
    Map<String, dynamic> mapOperation = {
      "senderID": senderID,
      "receiverID": receiverID,
      "robotID": robotID,
      "signature": senderSignature.toString(),
    };
    return mapOperation.toString();
  }
}
