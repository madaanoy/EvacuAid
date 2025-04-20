import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

class BlguSummary extends StatefulWidget {
  const BlguSummary({super.key});

  @override
  State<BlguSummary> createState() => _BlguSummaryState();
}

class _BlguSummaryState extends State<BlguSummary> {
  final _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: TextButton(
        onPressed: () {
          _authService.blguSignOut(context);
      }, child: Text("logout")),
      bottomNavigationBar: const BlguNavbar(0),
    );
  }
}
