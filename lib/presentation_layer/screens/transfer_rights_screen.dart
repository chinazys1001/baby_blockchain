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
  Signature signature =
      Signature.signData({"id": 12, "amount": 0xff}, currentKeyPair);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        Signature.verifySignature(
                signature, {"id": 12, "amount": 0xff}, currentKeyPair)
            .toString(),
        style: const TextStyle(fontSize: mediumFontSize),
      ),
    );
  }
}
