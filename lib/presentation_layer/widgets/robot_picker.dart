import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:baby_blockchain/presentation_layer/custom_dropdown/custom_dropdown.dart';
import 'package:line_icons/line_icons.dart';

class RobotPicker extends StatefulWidget {
  const RobotPicker({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<RobotPicker> createState() => _RobotPickerState();
}

class _RobotPickerState extends State<RobotPicker> {
  List<String> robotNames = [];
  bool isChosenRobotInTestMode = false;

  @override
  void initState() {
    for (Robot robot in verifiedAccount!.robots) {
      robotNames.add(robot.robotName);
    }
    super.initState();
  }

  Widget getRobotForm() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Icon(
            LineIcons.robot,
            size: 160,
            color: AccentColor,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width < mobileScreenMaxWidthh
                ? 5
                : 0,
          ),
          SizedBox(
            width: 340,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomDropdown.search(
                textAlign: TextAlign.center,
                hintText: 'Robot to be sent...',
                items: robotNames,
                searchHint: 'Search...',
                onNoResult: 'Robot not found :(',
                overlayBorderRadius: 7.0,
                selectedStyle: GoogleFonts.orbitron(
                  fontSize: 40,
                  color: DarkColor.withOpacity(0.7),
                  fontWeight: FontWeight.w100,
                ),
                hintStyle: GoogleFonts.roboto(
                  fontSize: mediumFontSize,
                  color: Colors.black38,
                ),
                borderSide: const BorderSide(width: 1, color: DarkColor),
                errorBorderSide: const BorderSide(width: 1, color: Colors.red),
                isOutlineBorder: false,
                borderRadius: smallBorderRadius,
                controller: widget.controller,
                onChanged: (selectedName) {
                  setState(() {
                    isChosenRobotInTestMode = verifiedAccount!.robots
                        .singleWhere(
                            (Robot robot) => robot.robotName == selectedName)
                        .isTestMode;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: LightColor,
      shadowColor: Colors.blueGrey,
      borderRadius: mediumBorderRadius,
      child: isChosenRobotInTestMode
          ? ClipRect(
              child: Banner(
                message: "Test Mode",
                location: BannerLocation.topEnd,
                color: IndicatorColor,
                child: getRobotForm(),
              ),
            )
          : getRobotForm(),
    );
  }
}
