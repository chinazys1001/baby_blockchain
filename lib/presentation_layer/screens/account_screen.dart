import 'dart:convert';

import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/login_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/key_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hex/hex.dart';
import 'package:line_icons/line_icons.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    if (verifiedAccount == null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => const SignInScreen(),
          ),
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: MediaQuery.of(context).size.width < 600
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AccentColor,
              centerTitle: true,
              title: Text(
                'BabyBlockchain',
                style: GoogleFonts.fredokaOne(
                  color: LightColor,
                  fontSize: bigFontSize,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    tooltip: "Click to sign out",
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, a1, a2) => const SignInScreen(),
                        ),
                      );
                      verifiedAccount = null;
                    },
                    icon: const Icon(LineIcons.alternateSignOut, size: 30),
                  ),
                ),
              ],
            )
          : null,
      body: MediaQuery.of(context).size.width < 1000
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: KeyCard(
                          value: base64Encode(
                            HEX.decode(
                              // ignore: invalid_use_of_protected_member
                              verifiedAccount!.keyPair.privateKey.toString(),
                            ),
                          ),
                          isPrivateKey: true,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 40,
                          left: 20,
                          right: 20,
                        ),
                        child: KeyCard(
                          // ignore: invalid_use_of_protected_member
                          value: verifiedAccount!.keyPair.publicKey.toString(),
                          isPrivateKey: false,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyCard(
                    value: base64Encode(
                      HEX.decode(
                        // ignore: invalid_use_of_protected_member
                        verifiedAccount!.keyPair.privateKey.toString(),
                      ),
                    ),
                    isPrivateKey: true,
                    context: context,
                  ),
                  KeyCard(
                    // ignore: invalid_use_of_protected_member
                    value: verifiedAccount!.keyPair.publicKey.toString(),
                    isPrivateKey: false,
                    context: context,
                  ),
                ],
              ),
            ),
      floatingActionButton: MediaQuery.of(context).size.width < 600
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                tooltip: "Click to sign out",
                backgroundColor: AccentColor,
                foregroundColor: LightColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, a1, a2) => const SignInScreen(),
                    ),
                  );
                  verifiedAccount = null;
                },
                child: const Icon(LineIcons.alternateSignOut),
              ),
            ),
    );
  }
}
