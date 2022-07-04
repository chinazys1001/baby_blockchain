import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferRightsScreen extends StatefulWidget {
  const TransferRightsScreen({Key? key}) : super(key: key);

  @override
  State<TransferRightsScreen> createState() => _TransferRightsScreenState();
}

class _TransferRightsScreenState extends State<TransferRightsScreen> {
  @override
  void initState() {
    if (currentAccount == null) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: MediaQuery.of(context).size.width < 600
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
      body: const Center(
        child: Text(
          "transfer rights screen",
          style: TextStyle(fontSize: mediumFontSize),
        ),
      ),
    );
  }
}
