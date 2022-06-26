import 'package:baby_blockchain/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index % 3 == 1
                ? AccentColor
                : index % 3 == 0
                    ? LightColor
                    : IndicatorColor,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
