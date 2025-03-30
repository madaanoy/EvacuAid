import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BLGUScreen extends StatelessWidget {
  const BLGUScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Who are you?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Image
            Image.asset(
              'assets/images/Govt-Employee.jpg', // Replace with actual image path
              height: 150,
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Lorem ipsum',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // "I have an account" button
            ElevatedButton(
              onPressed: () {
                context.push('/login'); // Route to BLGU Login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text("I have an account"),
            ),
            const SizedBox(height: 16),

            // "I do not have an account" button
            ElevatedButton(
              onPressed: () {
                context.push('/register'); // Route to BLGU Register screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text("I do not have an account"),
            ),
          ],
        ),
      ),
    );
  }
}
