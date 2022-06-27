import 'package:baby_blockchain/constants.dart';
import 'package:baby_blockchain/domain_layer/key_pair.dart';
import 'package:baby_blockchain/domain_layer/signature.dart';
import 'package:flutter/material.dart';

class TransferRightsScreen extends StatefulWidget {
  const TransferRightsScreen({Key? key}) : super(key: key);

  @override
  State<TransferRightsScreen> createState() => _TransferRightsScreenState();
}

class _TransferRightsScreenState extends State<TransferRightsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "",
        style: const TextStyle(fontSize: mediumFontSize),
      ),
    );
  }
}
