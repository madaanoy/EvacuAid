import 'package:flutter/material.dart';

class BlguNavbar extends StatefulWidget {
  const BlguNavbar({ super.key });

  @override
  State<BlguNavbar> createState() => _BlguNavbarState();
}

class _BlguNavbarState extends State<BlguNavbar> {
  @override
  Widget build(BuildContext context) {
      int _selectedIndex = 0;
    
    return Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffE5E5E5)))),
        child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.content_paste_rounded), label: 'Summary'),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom_rounded),
            label: 'Families',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home_work_rounded), label: 'Centers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_rounded),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff0438D1),
        unselectedItemColor: Color(0xff020202),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ));
  }
}