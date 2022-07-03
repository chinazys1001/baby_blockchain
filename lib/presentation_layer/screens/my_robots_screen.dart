import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';

class MyRobotsScreen extends StatefulWidget {
  const MyRobotsScreen({Key? key}) : super(key: key);

  @override
  State<MyRobotsScreen> createState() => _MyRobotsScreenState();
}

class _MyRobotsScreenState extends State<MyRobotsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "my robots screen",
        style: TextStyle(fontSize: mediumFontSize),
      ),
    );
  }
}
