import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
    this.isSmall = false,
  }) : super(key: key);

  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: isSmall ? 23 : 50,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index % 3 == 1
                ? IndicatorColor
                : index % 3 == 0
                    ? AdditionalIndicatorColor
                    : AccentColor,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
