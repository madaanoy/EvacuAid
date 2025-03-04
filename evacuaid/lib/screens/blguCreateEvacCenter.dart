import 'package:flutter/material.dart';
import '../widgets/BlguNavbar.dart';
import '../widgets/MainAppBar.dart';

class BlguCreateEvacCenter extends StatelessWidget {
  const BlguCreateEvacCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Text('Evac Center'),
      bottomNavigationBar: const BlguNavbar(2),
    );
  }
}
