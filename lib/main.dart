import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kcc_management_software/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          authDomain: 'kcc-membership-software.firebaseapp.com',
          apiKey: "AIzaSyC8_H46SpFo-k71y_4PIcbhHyFBIbgqyOA",
          appId: "1:998351460963:web:352c1a8627c117308d7656",
          messagingSenderId: "998351460963",
          projectId: "kcc-membership-software",
          storageBucket: "kcc-membership-software.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'KCC Management Software',
      home: LoginScreen(),
    );
  }
}
