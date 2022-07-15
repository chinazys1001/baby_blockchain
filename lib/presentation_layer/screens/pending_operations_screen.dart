import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_in_screen.dart';
import 'package:baby_blockchain/presentation_layer/widgets/empty_banners.dart';
import 'package:baby_blockchain/presentation_layer/widgets/loading_indicator.dart';
import 'package:baby_blockchain/presentation_layer/widgets/transactions_table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingOperationsScreen extends StatefulWidget {
  const PendingOperationsScreen({Key? key}) : super(key: key);

  @override
  State<PendingOperationsScreen> createState() =>
      _PendingOperationsScreenState();
}

class _PendingOperationsScreenState extends State<PendingOperationsScreen> {
  bool dataWasFetched = false;
  List<String> robotIDs = [], receiverIDs = [];

  Future<void> _getOperations() async {
    List<Operation> operations = await verifiedAccount!.getPendingOperations();

    for (Operation operation in operations) {
      robotIDs.add(operation.robotID);
      receiverIDs.add(operation.receiverID);
    }

    setState(() {
      dataWasFetched = true;
    });
  }

  @override
  void initState() {
    if (verifiedAccount == null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => const SignInScreen(),
          ),
        );
      });
    } else {
      _getOperations();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
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
      ),
      body: !dataWasFetched
          ? const LoadingIndicator()
          : robotIDs.isEmpty
              ? const EmptyMempoolBanner()
              : OperationsTable(
                  robotIDs: robotIDs,
                  receiverIDs: receiverIDs,
                ),
    );
  }
}
