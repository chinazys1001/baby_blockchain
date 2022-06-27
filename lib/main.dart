import 'package:baby_blockchain/data_layer/firebase_options.dart';
import 'package:baby_blockchain/presentation_layer/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // connecting to firebase services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'BabyBlockchain',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
