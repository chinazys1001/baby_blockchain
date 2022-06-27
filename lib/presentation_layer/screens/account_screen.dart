import 'package:baby_blockchain/constants.dart';
import 'package:baby_blockchain/domain_layer/key_pair.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '',
        //currentKeyPair.publicKey.toString(),
        style: const TextStyle(fontSize: mediumFontSize),
      ),
    );
  }
}
