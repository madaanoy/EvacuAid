/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-58] [DEV] Estalbish Evacuation Screen
Description: Ticket [EVA-42]'[UI] Establish Evaciation Screen' must be coded. 
This is where you can add evacuation centers or kabarangay shelters.
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlguNavbar extends StatelessWidget {
  // const BlguNavbar({Key? key}) : super(key: key);
  final int activeIndex;
  const BlguNavbar(this.activeIndex, {super.key});

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
            icon: Icon(Icons.family_restroom_rounded),
            label: 'Families',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_rounded),
            label: 'Centers',
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
              context.go('/');
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
