import 'package:flutter/material.dart';

import 'Screens/Login/loginScreen.dart';

void main() {
  runApp(const HerreraApp());
}

class HerreraApp extends StatelessWidget {
  const HerreraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorbetería Herrera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B889),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
