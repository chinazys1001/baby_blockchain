import 'dart:convert';

import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/widgets/key_card.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 600
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 15,
                    left: 30,
                    right: 30,
                  ),
                  child: KeyCard(
                    value: base64Encode(
                      HEX.decode(
                        // ignore: invalid_use_of_protected_member
                        currentAccount!.keyPair.privateKey.toString(),
                      ),
                    ),
                    isPrivateKey: true,
                    context: context,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 30,
                    left: 30,
                    right: 30,
                  ),
                  child: KeyCard(
                    // ignore: invalid_use_of_protected_member
                    value: currentAccount!.keyPair.publicKey.toString(),
                    isPrivateKey: false,
                    context: context,
                  ),
                ),
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              KeyCard(
                value: base64Encode(
                  HEX.decode(
                    // ignore: invalid_use_of_protected_member
                    currentAccount!.keyPair.privateKey.toString(),
                  ),
                ),
                isPrivateKey: true,
                context: context,
              ),
              KeyCard(
                // ignore: invalid_use_of_protected_member
                value: currentAccount!.keyPair.publicKey.toString(),
                isPrivateKey: false,
                context: context,
              ),
            ],
          );
  }
}
