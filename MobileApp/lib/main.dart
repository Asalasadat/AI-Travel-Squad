import 'package:flutter/material.dart';
import 'package:travelai/screens/splash_screen.dart';

void main() {
  runApp(const AITravelSquad());
}

class AITravelSquad extends StatelessWidget {
  const AITravelSquad({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Travel Squad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}