import 'dart:convert';

import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_indicator.dart';
import 'package:baby_blockchain/presentation_layer/common_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:hex/hex.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motion_toast/motion_toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = true;

  Widget showPrivateKey() => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < 600
              ? (MediaQuery.of(context).size.width - 320) / 2
              : (MediaQuery.of(context).size.width - 390) / 2,
          vertical: MediaQuery.of(context).size.width < 600
              ? (MediaQuery.of(context).size.height - 254) / 2
              : (MediaQuery.of(context).size.height - 239) / 2,
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Save your private key',
                    style: TextStyle(fontSize: 22, color: LightColor),
                  ),
                ),
                const SizedBox(height: 15),
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: smallBorderRadius,
                    side: BorderSide(width: 1, color: LightColor),
                  ),
                  color: Colors.transparent,
                  surfaceTintColor: ShadowColor,
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                    onTap: () async {
                      List<int> privateKeyBytes = HEX.decode(
                        // ignore: invalid_use_of_protected_member
                        verifiedAccount!.keyPair.privateKey.toString(),
                      );
                      await Clipboard.setData(
                        ClipboardData(
                          text: base64Encode(privateKeyBytes),
                        ),
                      ).then(
                        (value) => MotionToast.success(
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Private key was copied to clipboard",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          description: const Text(
                            "Use it to login to your account",
                          ),
                          toastDuration: const Duration(seconds: 5),
                        ).show(context),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(LineIcons.copy),
                      color: Theme.of(context).backgroundColor,
                      splashRadius: 0.001,
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        List<int> privateKeyBytes = HEX.decode(
                          // ignore: invalid_use_of_protected_member
                          verifiedAccount!.keyPair.privateKey.toString(),
                        );
                        await Clipboard.setData(
                          ClipboardData(
                            text: base64Encode(privateKeyBytes),
                          ),
                        ).then(
                          (value) => MotionToast.success(
                            title: const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Private key was copied to clipboard",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            description: const Text(
                              "Use it to login to your account",
                            ),
                            toastDuration: const Duration(seconds: 5),
                          ).show(context),
                        );
                      },
                    ),
                    horizontalTitleGap: 5,
                    contentPadding: const EdgeInsets.only(
                      left: 15,
                      right: 7.5,
                      top: 10,
                      bottom: 10,
                    ),
                    title: Text(
                      base64Encode(
                        HEX.decode(
                          // ignore: invalid_use_of_protected_member
                          verifiedAccount!.keyPair.privateKey.toString(),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: smallFontSize,
                        color: LightColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width < 600 ? 15 : 20),
                  color: ShadowColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, a1, a2) => const CommonLayout()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: mediumFontSize,
                          color: LightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            )).asGlass(
          clipBorderRadius: mediumBorderRadius,
          frosted: false,
          blurX: 15,
          blurY: 15,
        ),
      );

  Widget getLoadingWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          LoadingIndicator(),
          SizedBox(height: 10),
          Text(
            "Setting up your account...",
            style: TextStyle(
              color: LightColor,
              fontSize: mediumFontSize,
            ),
          )
        ],
      );

  Future setupAccount() async {
    Future.delayed(
      Duration.zero,
      () async {
        await Account.genAccount().then(
          (generatedAccount) {
            verifiedAccount = generatedAccount;
            if (verifiedAccount != null) {
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    setupAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading ? getLoadingWidget() : showPrivateKey(),
      ),
    );
  }
}
