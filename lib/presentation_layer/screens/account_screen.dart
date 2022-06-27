import 'package:baby_blockchain/constants.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'account screen',
        style: TextStyle(fontSize: mediumFontSize),
      ),
    );
  }
}
