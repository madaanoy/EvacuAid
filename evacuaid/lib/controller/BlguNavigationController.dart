import 'package:flutter/material.dart';

class BlguNavigationController with ChangeNotifier {
  String screenName = '/';

  void changeScreen(String newScreenName) {
    screenName = newScreenName;
    notifyListeners();
  }
}