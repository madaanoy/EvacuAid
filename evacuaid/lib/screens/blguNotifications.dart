/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-64] [DEV] BLGU Notifications Screen
Description: 
This is where you can view and see if your report has been sent.
*/

import 'package:evacuaid/widgets/notification.dart';
import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

class BlguNotifications extends StatelessWidget {
  const BlguNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            NotificationWidget(receiver: "MSWDO", date: '8:00 PM, January 24, 2025'),
            NotificationWidget(receiver: "BLGU", date: '6:00 PM, January 24, 2025'),
            NotificationWidget(receiver: "BLGU", date: '5:40 PM, January 24, 2025'),
            NotificationWidget(receiver: "MSWDO", date: '5:30 PM, January 24, 2025'),
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(3),
    );
  }
}
