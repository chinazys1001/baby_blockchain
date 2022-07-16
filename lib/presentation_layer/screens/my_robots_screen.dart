import 'dart:math';

import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/blockchain.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_in_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/empty_banners.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_indicator.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_overlay.dart';
import 'package:baby_blockchain/presentation_layer/widgets/robot_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motion_toast/motion_toast.dart';

class MyRobotsScreen extends StatefulWidget {
  const MyRobotsScreen({Key? key}) : super(key: key);

  @override
  State<MyRobotsScreen> createState() => _MyRobotsScreenState();
}

class _MyRobotsScreenState extends State<MyRobotsScreen> {
  ScrollController scrollController = ScrollController();
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
      _updateRobots();
    }
    super.initState();
  }

  bool updatedRobots = false;
  Future<void> _updateRobots() async {
    await verifiedAccount!.updateAccountRobots().then((value) => setState(() {
          robotsList = verifiedAccount!.robots.toList();
          updatedRobots = true;
        }));
  }

  void _createTestBot(BuildContext context) async {
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
              Future.delayed(
                Duration.zero,
                () {
                  scrollController.animateTo(
                    1.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              );
            },
          ),
        );
  }

  double _getPadding(BuildContext context) {
    double minDimension = min(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    if (minDimension < 555) return 30;
    return 60;
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
          "BabyBlockchain",
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
                    tooltip: "Create a robot for testing",
                    onPressed: () {
                      _createTestBot(context);
                    },
                    icon: const Icon(
                      LineIcons.plus,
                      color: LightColor,
                      size: 30,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: !updatedRobots
          ? const LoadingIndicator()
          : robotsList.isEmpty
              ? const NoOwnedRobotsBanner()
              : GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width ~/
                        (300 + _getPadding(context)),
                    mainAxisExtent: 310,
                  ),
                  padding: EdgeInsets.only(
                    left: _getPadding(context),
                    bottom: _getPadding(context),
                  ),
                  itemCount: robotsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Align(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          right: _getPadding(context),
                          top: _getPadding(context),
                          bottom: 0,
                        ),
                        child: RobotCard(
                          robotName: robotsList[index].robotName,
                          isTestMode: robotsList[index].isTestMode,
                          onNameChanged: (String newRobotName) async {
                            checkAndShowLoading(
                              context,
                              'Renaming: "${robotsList[index].robotName}" to "$newRobotName"...',
                            );
                            await verifiedAccount!
                                .changeRobotName(
                                    robotsList[index], newRobotName)
                                .then((value) {
                              setState(() {
                                Navigator.pop(context);
                              });

                              MotionToast.success(
                                title: const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "Robot's name was updated",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                description: Text(
                                  "New robot's " 'name is "$newRobotName"',
                                ),
                                toastDuration: const Duration(seconds: 5),
                              ).show(context);
                            });
                          },
                        ),
                      ),
                    );
                  },
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
                        tooltip: "Create a robot for testing",
                        backgroundColor: PrimaryColor,
                        foregroundColor: LightColor,
                        onPressed: () async {
                          _createTestBot(context);
                        },
                        child: const Icon(LineIcons.plus),
                      ),
                    ),
                  ),
                ),
    );
  }
}
