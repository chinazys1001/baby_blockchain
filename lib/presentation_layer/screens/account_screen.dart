import 'dart:convert';

import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_in_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/key_card.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_overlay.dart';
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

  void _signOut(context) {
    checkAndShowLoading(context, "Signing out");
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a1, a2) => const SignInScreen(),
        ),
      );
      verifiedAccount = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PrimaryColor,
        centerTitle: true,
        title: Text(
          'BabyBlockchain',
          style: GoogleFonts.fredokaOne(
            color: PrimaryLightColor,
            fontSize: bigFontSize,
          ),
        ),
        actions: MediaQuery.of(context).size.width < mobileScreenMaxWidth
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    tooltip: "Click to sign out",
                    onPressed: () {
                      _signOut(context);
                    },
                    icon: const Icon(
                      LineIcons.alternateSignOut,
                      color: LightColor,
                      size: 30,
                    ),
                  ),
                ),
              ]
            : null,
      ),
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
      floatingActionButton:
          MediaQuery.of(context).size.width < mobileScreenMaxWidth
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: FittedBox(
                      child: FloatingActionButton(
                        tooltip: "Click to sign out",
                        backgroundColor: PrimaryColor,
                        foregroundColor: LightColor,
                        onPressed: () {
                          _signOut(context);
                        },
                        child: const Icon(LineIcons.alternateSignOut),
                      ),
                    ),
                  ),
                ),
    );
  }
}
