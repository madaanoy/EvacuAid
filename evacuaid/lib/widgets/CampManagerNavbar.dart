/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-66] [DEV] BLGU Navigation Bar Component
Description: Ticket [EVA-65]'[UI] BLGU Navigation Bar Component' must be coded. 
This is where navigate through screens such as Summary, Families, Centers, and Notifications.
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CampManagerNavbar extends StatelessWidget {
  // const BlguNavbar({Key? key}) : super(key: key);
  final int activeIndex;
  const CampManagerNavbar(this.activeIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Color(0xffE5E5E5))),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste_rounded),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Evacuees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_rounded),
            label: 'Notifications',
          ),
        ],
        currentIndex: activeIndex,
        selectedItemColor: Color(0xff0438D1),
        unselectedItemColor: Color(0xff020202),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go('/summary');
              break;
            case 1:
              context.go('/families');
              break;
            case 2:
              context.go('/centers');
              break;
            case 3:
              context.go('/notifications');
              break;
            default:
          }
        },
      ),
    );
  }
}
