import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds
    Timer(const Duration(seconds: 3), () {
      // After 3 seconds, navigate to next screen
      // If you're using GoRouter:
      context.go('/login'); // change '/home' to your target route
      // If you're using Navigator:
      // Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
        color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main Title
                Image(
                  height: 50,
                  image: AssetImage('assets/logos/logo.png')),
                const SizedBox(height: 16),

                // Subtitle / Tagline
                Text(
                  'In times of calamity, every second counts.\n'
                  'EvacuAid is here to streamline evacuation\n'
                  'efforts, ensuring that no one is left behind.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
