import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';

class TransferRightsScreen extends StatefulWidget {
  const TransferRightsScreen({Key? key}) : super(key: key);

  @override
  State<TransferRightsScreen> createState() => _TransferRightsScreenState();
}

class _TransferRightsScreenState extends State<TransferRightsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "transfer rights screen",
        style: TextStyle(fontSize: mediumFontSize),
      ),
    );
  }
}
