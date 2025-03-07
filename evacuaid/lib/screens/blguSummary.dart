import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

class BlguSummary extends StatelessWidget {
  const BlguSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Text("summary"),
      bottomNavigationBar: const BlguNavbar(0),
    );
  }
}
