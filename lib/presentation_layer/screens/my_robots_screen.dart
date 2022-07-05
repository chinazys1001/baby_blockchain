import 'package:baby_blockchain/data_layer/robot_database.dart';
import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/login_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_indicator.dart';
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
            )
          : null,
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: robotsList.length,
        itemBuilder: (BuildContext context, int index) {
          return RobotCard(
            name: robotsList[index].robotName,
            isTestMode: robotsList[index].isTestMode,
            context: context,
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton(
          tooltip: "Get a robot for testing",
          backgroundColor: AccentColor,
          foregroundColor: LightColor,
          onPressed: () async {
            checkAndShowLoading(context, "Creating a random TestBot...");
            Robot randomRobot = await Robot.generateRandomRobot(
              ownerID: verifiedAccount!.accountID,
              isTestMode: true,
            );
            await RobotDatabase.addRobot(randomRobot).then(
              (value) => Future.delayed(
                const Duration(seconds: 1),
                () => Navigator.pop(context),
              ),
            );
          },
          child: const Icon(LineIcons.plus),
        ),
      ),
    );
  }
}
