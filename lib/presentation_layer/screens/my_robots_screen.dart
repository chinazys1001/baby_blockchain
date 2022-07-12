import 'dart:math';

import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/blockchain.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_in_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/empty_banner.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_overlay.dart';
import 'package:baby_blockchain/presentation_layer/widgets/robot_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class MyRobotsScreen extends StatefulWidget {
  const MyRobotsScreen({Key? key}) : super(key: key);

  @override
  State<MyRobotsScreen> createState() => _MyRobotsScreenState();
}

class _MyRobotsScreenState extends State<MyRobotsScreen> {
  List<Robot> robotsList = [];

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
    } else {
      robotsList = List.from(verifiedAccount!.robots);
    }
    super.initState();
  }

  void createTestBot(BuildContext context) async {
    checkAndShowLoading(context, "Creating a random TestBot...");

    Robot randomRobot = await Robot.generateRandomRobot(
      ownerID: verifiedAccount!.accountID,
      isTestMode: true,
    );

    await verifiedAccount!.addRobot(randomRobot);

    await blockchain.robotDatabase
        .incrementNonce(verifiedAccount!.accountID)
        .then(
          (value) => Future.delayed(
            const Duration(seconds: 1),
            () {
              Navigator.pop(context);
              setState(() {
                robotsList = List.from(verifiedAccount!.robots);
              });
            },
          ),
        );
  }

  double getPadding(BuildContext context) {
    double minDimension = min(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    if (minDimension < 555) return 40;
    return 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: MediaQuery.of(context).size.width < mobileScreenMaxWidthh
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
                    tooltip: "Create a robot for testing",
                    onPressed: () {
                      createTestBot(context);
                    },
                    icon: const Icon(LineIcons.plus, size: 30),
                  ),
                ),
              ],
            )
          : null,
      body: robotsList.isEmpty
          ? const EmptyBunner()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/
                    (300 + getPadding(context)),
                mainAxisExtent: 310,
              ),
              padding: EdgeInsets.only(
                left: getPadding(context),
                bottom: getPadding(context),
              ),
              itemCount: robotsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: getPadding(context),
                    top: getPadding(context),
                    bottom: 0,
                  ),
                  child: RobotCard(
                    name: robotsList[index].robotName,
                    isTestMode: robotsList[index].isTestMode,
                    context: context,
                  ),
                );
              },
            ),
      floatingActionButton:
          MediaQuery.of(context).size.width < mobileScreenMaxWidthh
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: FittedBox(
                      child: FloatingActionButton(
                        tooltip: "Create a robot for testing",
                        backgroundColor: AccentColor,
                        foregroundColor: LightColor,
                        onPressed: () async {
                          createTestBot(context);
                        },
                        child: const Icon(LineIcons.plus),
                      ),
                    ),
                  ),
                ),
    );
  }
}
