/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-66] [DEV] BLGU Navigation Bar Component
Description: Ticket [EVA-65]'[UI] BLGU Navigation Bar Component' must be coded. 
This is where navigate through screens such as Summary, Families, Centers, and Notifications.
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
            icon: Icon(Icons.person_pin),
            label: 'Camp Managers',
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
              context.go('/camp_manager');
              break;
            default:
          }
        },
      ),
    );
  }
}
