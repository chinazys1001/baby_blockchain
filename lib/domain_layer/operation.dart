import 'dart:typed_data';

import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/hash.dart';
import 'package:baby_blockchain/domain_layer/signature.dart';
import 'package:flutter/foundation.dart';

/// Custom implementation of [Operation] class. Usage description can be found in README.
class Operation {
  Operation({
    required this.seller,
    required this.buyer,
    required this.robotID,
    required this.signature,
  });

  /// Account that claims to own the robot.
  final Account seller;

  /// Account the seller wants transfer ownership of the robot to.
  final Account buyer;

  /// ID of the robot to be "sold".
  final String robotID;

  // Seller signs the operation.
  Uint8List signature;

  // TODO: check seller != buyer
  // TODO: check if operation is unique (see ref.)

  /// Creating operation with given seller account, buyer account and robotID.
  static Operation createOperation(
      Account seller, Account buyer, String robotID) {
    // operation data to be signed
    Map<String, dynamic> operationData = {
      "seller": {
        "id": seller.id,
        "keyPair": seller.keyPair,
      },
      "buyer": {
        "id": buyer.id,
        "keyPair": buyer.keyPair,
      },
      "robotID": robotID,
    };

    // seller signs hashed operation data
    Uint8List signature =
        Signature.signData(operationData.toString(), seller.keyPair);

    return Operation(
      seller: seller,
      buyer: buyer,
      robotID: robotID,
      signature: signature,
    );
  }

  /// Checking if both signature is correct and seller does own robot with given id
  static bool verifyOperation(Operation operation) {
    // operation data that must have been signed
    Map<String, dynamic> operationData = {
      "seller": {
        "id": operation.seller.id,
        "keyPair": operation.seller.keyPair,
      },
      "buyer": {
        "id": operation.buyer.id,
        "keyPair": operation.buyer.keyPair,
      },
      "robotID": operation.robotID,
    };

    if (!Signature.verifySignature(operation.signature,
        operationData.toString(), operation.seller.keyPair)) {
      return false;
    }
    // TODO: check accountDatabase
    return true;
  }

  /// Testing-only
  void printOperation() {
    if (kDebugMode) {
      print("-----------------------Operation-----------------------");
      print("Seller: ${seller.toString()}");
      print("Buyer: ${buyer.toString()}");
      print("Robot: $robotID");
      print("Signature: ${signature.toString()}");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapOperation = {
      "seller": seller.toString(),
      "buyer": buyer.toString(),
      "robotID": robotID,
      "signature": signature.toString(),
    };
    return mapOperation.toString();
  }
}
