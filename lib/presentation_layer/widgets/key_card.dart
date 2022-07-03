import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motion_toast/motion_toast.dart';

class KeyCard extends StatelessWidget {
  const KeyCard({
    Key? key,
    required this.value,
    required this.isPrivateKey,
    required this.context,
  }) : super(key: key);

  final String value;
  final bool isPrivateKey;
  final BuildContext context;

  void copyKey() async {
    await Clipboard.setData(
      ClipboardData(text: value),
    ).then(
      (value) => MotionToast.success(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            isPrivateKey
                ? "Private key was copied to clipboard"
                : "Public key was copied to clipboard",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        description: Text(
          isPrivateKey
              ? "Use it to login to your account. Don't share it to anyone."
              : "Use it to receive transactions. Feel free to share it.",
        ),
        toastDuration: const Duration(seconds: 5),
      ).show(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: LightColor,
      shadowColor: ShadowColor,
      borderRadius: bigBorderRadius,
      child: InkWell(
        splashColor: AccentColor.withOpacity(0.5),
        highlightColor: AccentColor.withOpacity(0.5),
        borderRadius: bigBorderRadius,
        onTap: copyKey,
        onLongPress: copyKey,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Icon(
                isPrivateKey ? LineIcons.key : LineIcons.users,
                size: 70,
                color: AccentColor,
              ),
              const SizedBox(height: 15),
              Text(
                isPrivateKey ? "Private Key" : "Public Key",
                style: const TextStyle(fontSize: bigFontSize, color: DarkColor),
              ),
              const SizedBox(height: 15),
              Text(
                value,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: DarkColor.withOpacity(0.54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
