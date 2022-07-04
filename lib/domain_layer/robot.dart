import 'package:flutter/foundation.dart';

/// Basic instance of [Robot] class is defined with following objects:
/// `name` -> name of a robot with corresponding ID
/// `id` -> unique robot identifier
/// `owner` -> ID of master-account
/// `isTestMode` -> true if the robot was generated as an instance for testing
class Robot {
  const Robot({
    required this.id,
    required this.name,
    required this.owner,
    required this.isTestMode,
  });

  final String id;
  final String name;
  final String owner;
  final bool isTestMode;

  /// Testing-only
  void printRobot() {
    if (kDebugMode) {
      print("-------------------------Robot-------------------------");
      print("Robot ID: $id");
      print("Robot name: $name");
      print("Owner ID: $owner");
      print("-------------------------------------------------------");
    }
  }

  @override
  String toString() {
    Map<String, dynamic> mapTransaction = {
      "robotID": id,
      "robotName": name,
      "ownerID": owner,
      "isTestMode": isTestMode,
    };
    return mapTransaction.toString();
  }
}
