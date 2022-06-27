import 'package:baby_blockchain/constants.dart';
import 'package:baby_blockchain/presentation_layer/loading_indicator.dart';
import 'package:baby_blockchain/presentation_layer/ui_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool generatingKeyPair = false;
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
        child: kReleaseMode
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingIndicator(),
                  const SizedBox(height: 5),
                  const Text(
                    "Release date: 12.06.2022",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: bigFontSize,
                      color: LightColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: bigFontSize,
                        color: LightColor,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: "Track progress on ",
                        ),
                        TextSpan(
                          text: 'GitHub',
                          style: const TextStyle(
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
              )
            : generatingKeyPair
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      LoadingIndicator(),
                      SizedBox(height: 10),
                      Text(
                        'Setting up your demo-account...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: mediumFontSize,
                          color: LightColor,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width < 600
                          ? (MediaQuery.of(context).size.width - 320) / 2
                          : (MediaQuery.of(context).size.width - 390) / 2,
                      vertical: MediaQuery.of(context).size.width < 600
                          ? (MediaQuery.of(context).size.height - 430) / 2
                          : (MediaQuery.of(context).size.height - 390) / 2,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(height: 15),
                            const Text(
                              'ДИСКЛЕЙМЕР',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: bigFontSize, color: LightColor),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              height: 0,
                              thickness: 2,
                              color: LightColor,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Мета створення цього застосунку - продемонструвати етапи взаємодії користувача з блокчейном у розглянутому продукті. Тому багато фічей, які б мали бути в життєздатному продукті, або зовсім не включені в цей застосунок, або "натяк" на них залишен в вигляді неклікабельних кнопок. Зокрема, тут мала б бути sign-in/sign-up форма для зручного входу в застосунок. Натомість, кожного разу буде створюватися новий демо-акаунт, на якому для тестування будуть доступні цифрові права власності на 2 роботів.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: LightColor,
                                fontSize: smallFontSize,
                              ),
                            ),
                            const SizedBox(height: 15),
                            MaterialButton(
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width < 600
                                      ? 15
                                      : 20),
                              color: ShadowColor,
                              onPressed: () async {
                                setState(() {
                                  generatingKeyPair = true;
                                });
                                Future.delayed(
                                  Duration.zero,
                                  () async {
                                    //currentKeyPair = KeyPair.genKeyPair();
                                  },
                                );
                                Future.delayed(
                                  const Duration(seconds: 3),
                                  () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (_, a1, a2) =>
                                              const UILayout()),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                "Створити демо-акаунт",
                                style: TextStyle(
                                  fontSize: mediumFontSize,
                                  color: LightColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        )).asGlass(
                      clipBorderRadius: BorderRadius.circular(20),
                      frosted: false,
                      blurX: 15,
                      blurY: 15,
                    ),
                  ),
      ),
    );
  }
}
