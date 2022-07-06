import 'package:baby_blockchain/data_layer/firebase_options.dart';
import 'package:baby_blockchain/domain_layer/account.dart';
import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/common_layout.dart';
import 'package:baby_blockchain/presentation_layer/screens/registration/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // connecting to firebase services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await Account.tryToSignInToAccount(
  //     "Rjr5CrqiO8WQGq9s1FYtb/XWpZ3AncW+N+JSUgkytZ8=");

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
      home: const SignInScreen(),
    );
  }
}
