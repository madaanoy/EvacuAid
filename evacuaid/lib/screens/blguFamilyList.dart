import 'package:flutter/material.dart';
import '../widgets/BlguNavbar.dart';
import '../widgets/MainAppBar.dart';

class BlguFamilyList extends StatelessWidget {
  const BlguFamilyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Text('Families'),
      bottomNavigationBar: const BlguNavbar(1),
    );
  }
}
