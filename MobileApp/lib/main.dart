import 'package:flutter/material.dart';

import 'package:travelai/screens/splash_screen.dart';
import 'package:travelai/screens/home_screen.dart';
import 'package:travelai/screens/preferences_screen.dart';

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

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),

        '/home': (context) => const HomeScreen(),

        '/preferences': (context) => const PreferencesScreen(),
      },
    );
  }
}