import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_indicator.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_up_screen.dart';
import 'package:baby_blockchain/presentation_layer/common_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;

  @override
  void initState() {
    if (verifiedAccount != null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => const CommonLayout(),
          ),
        );
      });
    }
    super.initState();
  }

  Widget getBanner() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(),
          const SizedBox(height: 5),
          Text(
            "Release date: 12.07.2022",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: bigFontSize,
              color: LightColor,
              fontWeight:
                  MediaQuery.of(context).size.width < mobileScreenMaxWidthh
                      ? FontWeight.bold
                      : null,
            ),
          ),
          const SizedBox(height: 5),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyle(
                fontSize: bigFontSize,
                color: LightColor,
                fontWeight:
                    MediaQuery.of(context).size.width < mobileScreenMaxWidthh
                        ? FontWeight.bold
                        : null,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: "Track progress on ",
                ),
                TextSpan(
                  text: 'GitHub',
                  style: TextStyle(
                    fontSize: bigFontSize,
                    color: IndicatorColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launchUrlString(
                          "https://github.com/chinazys1001/baby_blockchain");
                    },
                ),
              ],
            ),
          ),
        ],
      );

  TextEditingController keyTextController = TextEditingController();
  FocusNode keyFocusNode = FocusNode();
  Widget getLoginForm() => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < mobileScreenMaxWidthh
              ? (MediaQuery.of(context).size.width - 320) / 2
              : (MediaQuery.of(context).size.width - 390) / 2,
          vertical: MediaQuery.of(context).size.width < mobileScreenMaxWidthh
              ? (MediaQuery.of(context).size.height - 285) / 2
              : (MediaQuery.of(context).size.height - 270) / 2,
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
                    'Login with your private key',
                    style: TextStyle(
                      fontSize: mediumFontSize,
                      color: LightColor,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: smallBorderRadius,
                  ),
                  color: Colors.transparent,
                  child: TextFormField(
                    controller: keyTextController,
                    focusNode: keyFocusNode,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    minLines: 2,
                    maxLines: 2,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onTap: () {
                      setState(() {});
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) async {
                      await tryToSignIn();
                    },
                    style: const TextStyle(
                      color: LightColor,
                      fontSize: smallFontSize,
                    ),
                    decoration: InputDecoration(
                      helperMaxLines: 3,
                      hintText: "Private key goes here...",
                      hintStyle: TextStyle(
                        color: LightColor.withOpacity(0.67),
                        fontSize: smallFontSize,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: smallBorderRadius,
                        borderSide: BorderSide(
                          color: BackgroundColor,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: smallBorderRadius,
                        borderSide: BorderSide(
                          color: LightColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width < mobileScreenMaxWidthh
                          ? 15
                          : 20),
                  color: ShadowColor,
                  onPressed: () async {
                    await tryToSignIn();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: verificationInProgress,
                        child: const LoadingIndicator(isSmall: true),
                      ),
                      Visibility(
                        visible: !verificationInProgress,
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: mediumFontSize,
                            color: LightColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: smallFontSize,
                      color: LightColor,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Not registered yet? ',
                      ),
                      TextSpan(
                        text: 'Create an Account',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: IndicatorColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, a1, a2) =>
                                    const SignUpScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )).asGlass(
          clipBorderRadius: mediumBorderRadius,
          frosted: false,
          blurX: 15,
          blurY: 15,
        ),
      );

  bool verificationInProgress = false;
  Future<void> tryToSignIn() async {
    if (verificationInProgress) return;
    setState(() {
      verificationInProgress = true;
    });
    keyFocusNode.unfocus();
    if (keyTextController.text.isEmpty) {
      MotionToast.info(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            "Provide your private key",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        description: const Text(
          "Paste your private key in the field above to sign in",
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context);
      return;
    }
    await Account.tryToSignInToAccount(keyTextController.text).then(
      (confirmed) {
        if (!confirmed) {
          MotionToast.error(
            title: const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                "Invalid private key",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            description: const Text(
              "Check if the provided private key was entered correctly",
            ),
            toastDuration: const Duration(seconds: 5),
          ).show(context);
          return;
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => const CommonLayout(),
          ),
        );
      },
    );
    setState(() {
      verificationInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: BackgroundColor,
      body: GestureDetector(
        onTap: () {
          setState(() {
            keyFocusNode.unfocus();
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/welcome_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: kReleaseMode ? getBanner() : getLoginForm(),
        ),
      ),
    );
  }
}
