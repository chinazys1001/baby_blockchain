import 'dart:typed_data';

import 'package:baby_blockchain/data_layer/robot_database.dart';
import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/domain_layer/signature.dart';
import 'package:flutter/foundation.dart';

/// Custom implementation of [Operation] class. Usage description can be found in README.
class Operation {
  Operation({
    required this.seller,
    required this.buyer,
    required this.robotID,
    required this.sellerSignature,
  });

  /// Account that claims to own the robot.
  final Account seller;

  /// Account the seller wants transfer ownership of the robot to.
  final Account buyer;

  /// ID of the robot to be "sold".
  final String robotID;

  // Seller signs the operation.
  Uint8List sellerSignature;

  // TODO: check if operation is unique (see ref.)

  /// Creating operation with given seller account, buyer account and robotID.
  static Operation createOperation(
      Account seller, Account buyer, String robotID) {
    if (seller == buyer) {
      throw ArgumentError(
        "Seller cannot be equal to buyer",
        seller.toString(),
      );
    }

    // operation data to be signed
    Map<String, dynamic> operationData = {
      "seller": {
        "id": seller.accountID,
        "keyPair": seller.keyPair,
      },
      "buyer": {
        "id": buyer.accountID,
        "keyPair": buyer.keyPair,
      },
      "robotID": robotID,
    };

    // seller signs hashed operation data
    Uint8List sellerSignature =
        Signature.signData(operationData.toString(), seller.keyPair);

    return Operation(
      seller: seller,
      buyer: buyer,
      robotID: robotID,
      sellerSignature: sellerSignature,
    );
  }

  /// Checking if both signature is correct and seller does own robot with given id
  static Future<bool> verifyOperation(Operation operation) async {
    if (operation.seller == operation.buyer) return false;

    // operation data that must have been signed
    Map<String, dynamic> operationData = {
      "seller": {
        "id": operation.seller.accountID,
        "keyPair": operation.seller.keyPair,
      },
      "buyer": {
        "id": operation.buyer.accountID,
        "keyPair": operation.buyer.keyPair,
      },
      "robotID": operation.robotID,
    };

    // verifying signature of the data
    if (!Signature.verifySignature(operation.sellerSignature,
        operationData.toString(), operation.seller.keyPair)) {
      return false;
    }

    // verifying if the seller owns robot with given robotID
    Set<Robot> sellerRobots = await RobotDatabase.getRobots(
      operation.seller.accountID,
    ); // getting seller's robots from db
    if (sellerRobots
        .where((robot) => robot.robotID == operation.robotID)
        .isEmpty) {
      return false; // returning false if seller doesn't own the robot with corresponding robotID
    }

    return true;
  }

  /// Testing-only
  void printOperation() {
    if (kDebugMode) {
      print("-----------------------Operation-----------------------");
      print("Seller: ${seller.toString()}");
      print("Buyer: ${buyer.toString()}");
      print("Robot ID: $robotID");
      print("Signature: ${sellerSignature.toString()}");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapOperation = {
      "seller": seller.toString(),
      "buyer": buyer.toString(),
      "robotID": robotID,
      "signature": sellerSignature.toString(),
    };
    return mapOperation.toString();
  }
}
