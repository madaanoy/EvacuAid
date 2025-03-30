import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // If you have an asset image, make sure it's in your pubspec.yaml
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
                Text(
                  'EVACUAID',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xff0438D1),
                  ),
                ),
                
                const SizedBox(height: 16),
                // Subtitle / Tagline
                const Text(
                  'In times of calamity, every second counts.\n'
                  'EvacuAid is here to streamline evacuation efforts,\n'
                  'ensuring that no one is left behind.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // "I'm a BLGU" button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the BLGU summary route
                    context.push('/summary');
                  },
                  child: const Text("I'm a BLGU"),
                ),

                const SizedBox(height: 16),

                // "I'm a Camp Manager" button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the route for camp manager
                    context.push('/centers');
                  },
                  child: const Text("I'm a Camp Manager"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
