import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/blockchain.dart';
import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/domain_layer/transaction.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_in_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/receiver_picker.dart';
import 'package:baby_blockchain/presentation_layer/widgets/robot_picker.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:http/http.dart' as http;

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

    Robot robot = verifiedAccount!.robots
        .singleWhere((Robot robot) => robot.robotName == robotName);

    if (receiverID == robot.ownerID && mounted) {
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
        verifiedAccount!.createOperation(receiverID, robot.robotID);

    Transaction transaction = await Transaction.createTransaction(operation);

    await http
        .post(
      Uri.parse("http://localhost:8080/post/transaction"),
      body: transaction.toJSONString(),
    )
        .then((response) {
      print(response.body);
      Navigator.pop(context);
    });
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
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RobotPicker(controller: robotPickerController),
                ],
              ),
              const SizedBox(width: 15),
              const Icon(
                LineIcons.alternateLongArrowRight,
                size: 120,
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReceiverPicker(
                    controller: receiverPickerController,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: const StadiumBorder(),
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width < mobileScreenMaxWidthh
                    ? 15
                    : 20),
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
          ),
        ],
      ),
    );
  }
}
