import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

Future? loading;
checkAndShowLoading(BuildContext context, String message) async {
  if (loading == null) {
    loading = showLoading(context, message);
    await loading;
    loading = null;
  }
}

Future showLoading(BuildContext context, String message) async {
  return showAnimatedDialog(
    barrierDismissible: false,
    duration: const Duration(milliseconds: 500),
    animationType: DialogTransitionType.fade,
    axis: Axis.vertical,
    context: context,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(),
          const SizedBox(height: 10),
          DefaultTextStyle(
            style: const TextStyle(
              color: LightColor,
              fontSize: mediumFontSize,
            ),
            child: Text(message),
          ),
        ],
      );
    },
  );
}
