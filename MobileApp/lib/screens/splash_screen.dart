import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travelai/screens/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              Icons.travel_explore,
              size: 120,
              color: Colors.blue,
            ),

            SizedBox(height: 20),

            Text(
              "AI Travel Squad",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Discover Palestine with AI",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 40),

            CircularProgressIndicator(),

          ],
        ),
      ),
    );
  }
}