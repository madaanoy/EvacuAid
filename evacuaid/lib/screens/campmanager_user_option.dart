import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CampManagerScreen extends StatelessWidget {
  const CampManagerScreen({super.key});

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
              'assets/images/Camp-Manager.jpg', // Replace with actual image path
              height: 150,
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'The camp manager is backbone of your community’s disaster response. With EvacuAid, you can register family heads, track evacuees, and manage relief efforts seamlessly—ensuring that no one is left behind.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // "I have an account" button
            ElevatedButton(
              onPressed: () {
                context.push('/camp_manager_login'); // Route to Camp Manager Login screen
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
                context.push('/camp_manager_register'); // Route to Camp Manager Register screen
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