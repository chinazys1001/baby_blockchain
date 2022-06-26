import 'package:baby_blockchain/constants.dart';
import 'package:baby_blockchain/domain_layer/key_pair.dart';
import 'package:baby_blockchain/presentation_layer/loading_indicator.dart';
import 'package:baby_blockchain/presentation_layer/ui_layout.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

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
        child: generatingKeyPair
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
                          'Мета створення цього застосунку - продемонструвати етапи взаємодії користувача з блокчейном у розглянутому продукті. Тому багато фічей, які б мали бути в життєздатному продукті, або зовсім не включені в цей застосунок, або "натяк" на них залишен в вигляді неклікабельних кнопок. Наприклад, тут мала б бути sign-in/sign-up форма для зручного входу в застосунок. Натомість, кожного разу буде створюватися новий демо-акаунт для тестування, на якому будуть доступні цифрові права власності на 2 роботів.',
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
                                currentKeyPair = KeyPair.genKeyPair();
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
