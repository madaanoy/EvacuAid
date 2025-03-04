import 'package:flutter/material.dart';
import '../widgets/BlguNavbar.dart';
import '../widgets/MainAppBar.dart';

class BlguNotifications extends StatelessWidget {
  const BlguNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Text("notifications"),
      bottomNavigationBar: const BlguNavbar(3),
    );
  }
}
