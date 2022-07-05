import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class RobotCard extends StatelessWidget {
  const RobotCard({
    Key? key,
    required this.name,
    required this.isTestMode,
    required this.context,
  }) : super(key: key);

  final String name;
  final bool isTestMode;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: LightColor,
      shadowColor: Colors.blueGrey,
      borderRadius: bigBorderRadius,
      child: SizedBox(
        width: MediaQuery.of(context).size.width < 400
            ? 320
            : MediaQuery.of(context).size.width < 600
                ? 380
                : 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            const Icon(
              LineIcons.robot,
              size: 180,
              color: AccentColor,
            ),
            const SizedBox(height: 15),
            Text(
              name,
              maxLines: 1,
              style: const TextStyle(
                fontSize: bigFontSize * 2,
                color: DarkColor,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
