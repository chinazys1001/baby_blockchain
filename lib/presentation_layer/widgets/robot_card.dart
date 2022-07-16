import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class RobotCard extends StatefulWidget {
  const RobotCard({
    Key? key,
    required this.robotName,
    required this.isTestMode,
    required this.onNameChanged,
  }) : super(key: key);

  final String robotName;
  final bool isTestMode;
  final void Function(String newRobotName) onNameChanged;

  @override
  State<RobotCard> createState() => _RobotCardState();
}

class _RobotCardState extends State<RobotCard> {
  List<String> getAvailableRobotNames() {
    List<String> availableRobotNames = [];
    // saving the robotName without suffix
    String curRobotNameBase = widget.robotName;
    int dashInd = curRobotNameBase.indexOf('-');
    if (dashInd != -1) {
      curRobotNameBase = curRobotNameBase.substring(0, dashInd);
    }

    for (String robotName in randomRobotNames) {
      if (robotName != curRobotNameBase) {
        int namesakesCnt = verifiedAccount!.robots.where((robot) {
          // getting rid of suffix if robotNameTocCHek already contains it (e.g. Taras-__ -> Taras)
          String robotNameToCheck = robot.robotName;
          int dashInd = robotNameToCheck.indexOf('-');
          if (dashInd != -1) {
            robotNameToCheck = robotNameToCheck.substring(0, dashInd);
          }

          if (robotNameToCheck == robotName) return true;
          return false;
        }).length;

        if (namesakesCnt > 0) {
          availableRobotNames.add(
            "$robotName-${(namesakesCnt + 1).toString()}",
          );
        } else {
          availableRobotNames.add(robotName);
        }
      } else {
        availableRobotNames.add(widget.robotName);
      }
    }
    return availableRobotNames;
  }

  Future? namePickerDialog;
  checkAndShowNamePickerDialog(
      BuildContext context, TextEditingController robotNameController) async {
    if (namePickerDialog == null) {
      namePickerDialog = showNamePickerDialog(context, robotNameController);
      await namePickerDialog;
      namePickerDialog = null;
    }
  }

  Future showNamePickerDialog(
      BuildContext context, TextEditingController robotNameController) async {
    List<String> availableRobotNames = getAvailableRobotNames();

    return showAnimatedDialog(
        barrierDismissible: false,
        duration: const Duration(milliseconds: 500),
        animationType: DialogTransitionType.fade,
        axis: Axis.vertical,
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.only(
              bottom: 25,
              top: MediaQuery.of(context).size.width < 600 &&
                      MediaQuery.of(context).orientation ==
                          Orientation.landscape
                  ? 25
                  : kToolbarHeight,
              left: 10,
              right: 10,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: mediumBorderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomDropdown.search(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      textAlign: TextAlign.center,
                      hintText: 'New robot name...',
                      items: availableRobotNames,
                      searchHint: 'Search...',
                      onNoResult: 'Robot not found :(',
                      overlayBorderRadius: 7.0,
                      selectedStyle: GoogleFonts.orbitron(
                        fontSize: 38,
                        color: DarkColor.withOpacity(0.7),
                        fontWeight: FontWeight.w100,
                      ),
                      hintStyle: GoogleFonts.roboto(
                        fontSize: mediumFontSize,
                        color: Colors.black38,
                      ),
                      borderSide: const BorderSide(width: 1, color: DarkColor),
                      errorBorderSide:
                          const BorderSide(width: 1, color: Colors.red),
                      isOutlineBorder: false,
                      borderRadius: smallBorderRadius,
                      controller: robotNameController,
                      onChanged: (selectedName) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 320,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        shape: const StadiumBorder(
                            side: BorderSide(
                          color: PrimaryColor,
                          width: 2,
                        )),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width <
                                    mobileScreenMaxWidth
                                ? 15
                                : 20),
                        color: LightColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: mediumFontSize,
                                  color: PrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        shape: const StadiumBorder(),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width <
                                    mobileScreenMaxWidth
                                ? 15
                                : 20),
                        color: PrimaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                          if (widget.robotName != robotNameController.text) {
                            widget.onNameChanged(robotNameController.text);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  fontSize: mediumFontSize,
                                  color: LightColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  Widget _getRobotDemo() {
    TextEditingController robotNameController = TextEditingController();
    return InkWell(
      splashColor: PrimaryLightColor.withOpacity(0.5),
      highlightColor: PrimaryLightColor.withOpacity(0.25),
      borderRadius: mediumBorderRadius,
      onTap: () async {
        robotNameController.text = widget.robotName;
        await checkAndShowNamePickerDialog(context, robotNameController);
      },
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Icon(
              LineIcons.robot,
              size: 160,
              color: PrimaryLightColor,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width < mobileScreenMaxWidth
                  ? 10
                  : 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                widget.robotName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.orbitron(
                  fontSize: 38,
                  color: DarkColor.withOpacity(0.7),
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: LightColor,
      shadowColor: ShadowColor,
      borderRadius: mediumBorderRadius,
      child: widget.isTestMode
          ? ClipRect(
              child: Banner(
                message: "Test Mode",
                location: BannerLocation.topEnd,
                color: AccentColor,
                child: _getRobotDemo(),
              ),
            )
          : _getRobotDemo(),
    );
  }
}
