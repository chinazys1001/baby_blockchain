import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

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

  Widget getRobotDemo() {
    return InkWell(
      splashColor: AccentColor.withOpacity(0.5),
      highlightColor: AccentColor.withOpacity(0.5),
      borderRadius: mediumBorderRadius,
      onTap: () async {
        //TODO: (?)
        await http
            .post(Uri.parse("http://localhost:8080"))
            .then((response) => print(response.statusCode));
      },
      child: Column(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.orbitron(
                fontSize: 40,
                color: DarkColor.withOpacity(0.7),
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: LightColor,
      shadowColor: Colors.blueGrey,
      borderRadius: mediumBorderRadius,
      child: isTestMode
          ? ClipRect(
              child: Banner(
                message: "Test Mode",
                location: BannerLocation.topEnd,
                color: IndicatorColor,
                child: getRobotDemo(),
              ),
            )
          : getRobotDemo(),
    );
  }
}
