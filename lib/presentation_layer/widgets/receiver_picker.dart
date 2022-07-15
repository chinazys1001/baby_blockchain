import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/robot.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:line_icons/line_icons.dart';

class ReceiverPicker extends StatefulWidget {
  const ReceiverPicker({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<ReceiverPicker> createState() => _ReceiverPickerState();
}

class _ReceiverPickerState extends State<ReceiverPicker> {
  // TextEditingController receiverController = TextEditingController();
  List<String> robotNames = [];

  @override
  void initState() {
    for (Robot robot in verifiedAccount!.robots) {
      robotNames.add(robot.robotName);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: LightColor,
      shadowColor: Colors.blueGrey,
      borderRadius: bigBorderRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Icon(
            LineIcons.userSecret,
            size: 160,
            color: AccentColor,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width < mobileScreenMaxWidth
                ? 5
                : 0,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 340,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: widget.controller,
                onTap: null,
                onChanged: (value) {},
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: DarkColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Receiver ID...",
                  hintStyle: TextStyle(
                    fontSize: mediumFontSize,
                    color: Colors.black38,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: DarkColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: DarkColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: DarkColor),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ).asGlass(blurX: 15, blurY: 15, frosted: true),
    );
  }
}
