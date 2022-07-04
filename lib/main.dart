import 'package:baby_blockchain/data_layer/firebase_options.dart';
import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/login_screen.dart';
import 'package:baby_blockchain/presentation_layer/common_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // connecting to firebase services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  currentAccount = await Account.signInToAccount(
      "ojrBn7LIGuUfSOcli23jHzwqxqOUYvTAzQWC4LFRQgo=");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyBlockchain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AccentColor),
      home: const CommonLayout(),
    );
  }
}
