import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/blockchain.dart';
import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/domain_layer/transaction.dart';
import 'package:baby_blockchain/presentation_layer/common_layout.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/pending_operations_screen.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_in_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/empty_banners.dart';
import 'package:baby_blockchain/presentation_layer/widgets/receiver_picker.dart';
import 'package:baby_blockchain/presentation_layer/widgets/robot_picker.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motion_toast/motion_toast.dart';

class TransferRightsScreen extends StatefulWidget {
  const TransferRightsScreen({Key? key}) : super(key: key);

  @override
  State<TransferRightsScreen> createState() => _TransferRightsScreenState();
}

class _TransferRightsScreenState extends State<TransferRightsScreen> {
  TextEditingController robotPickerController = TextEditingController();
  TextEditingController receiverPickerController = TextEditingController();

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

  void _onConfirmButtonPressed() async {
    String robotName = robotPickerController.text;
    String receiverID = receiverPickerController.text;

    if (robotName.isEmpty || receiverID.isEmpty) {
      MotionToast.error(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            "Invalid operation",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        description: const Text(
          "Choose both robot and receiver to transfer ownership rights",
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context);

      return;
    }

    bool receiverIsValid = true;
    await blockchain.robotDatabase.accountExists(receiverID).then((exists) {
      if (!exists) {
        receiverIsValid = false;
        MotionToast.error(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "Invalid receiver ID",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          description: const Text(
            "Account with given ID was not found",
          ),
          toastDuration: const Duration(seconds: 5),
        ).show(context);

        return;
      }
    });
    if (!receiverIsValid) return;

    Robot robotToBeSent = verifiedAccount!.robots
        .singleWhere((Robot robot) => robot.robotName == robotName);

    if (receiverID == robotToBeSent.ownerID && mounted) {
      MotionToast.error(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            "Nice try",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        description: const Text(
          "but it did't work",
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context);

      return;
    }

    if (mounted) checkAndShowLoading(context, "Verifying transaction...");

    Operation operation =
        verifiedAccount!.createOperation(receiverID, robotToBeSent.robotID);

    Transaction transaction = await Transaction.createTransaction(operation);

    await Transaction.addTransactionToMempool(transaction).then((value) {
      // updating current state only
      setState(() {
        verifiedAccount!.removeRobot(robotToBeSent, updateDB: false);
      });
      Navigator.pop(context);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a1, a2) => const CommonLayout(screenIndex: 3),
        ),
      );
      MotionToast.success(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            "Robot was sent",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        description: Text(
          "${robotToBeSent.robotName} is on the way to its new owner",
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context);
    });
  }

  Widget _getConfirmButton() => MaterialButton(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.all(20),
        color: AccentColor,
        elevation: 8,
        onPressed: _onConfirmButtonPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Confirm",
                style: TextStyle(
                  fontSize: bigFontSize,
                  color: LightColor,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
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
      ),
      body: verifiedAccount!.robots.isEmpty
          ? const NoRobotsToTradeBanner()
          : MediaQuery.of(context).size.width < 900
              ? ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 30),
                    Align(
                      child: RobotPicker(controller: robotPickerController),
                    ),
                    const SizedBox(height: 5),
                    const Icon(
                      LineIcons.alternateLongArrowDown,
                      size: 120,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 5),
                    Align(
                      child: ReceiverPicker(
                        controller: receiverPickerController,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      child: _getConfirmButton(),
                    ),
                    const SizedBox(height: 30),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 15),
                        Align(
                          child: RobotPicker(controller: robotPickerController),
                        ),
                        const SizedBox(width: 15),
                        const Icon(
                          LineIcons.alternateLongArrowRight,
                          size: 120,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 15),
                        Align(
                          child: ReceiverPicker(
                            controller: receiverPickerController,
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _getConfirmButton(),
                    const SizedBox(height: 20),
                  ],
                ),
    );
  }
}
