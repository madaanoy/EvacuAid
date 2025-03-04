import 'package:evacuaid/screens/blguCreateEvacCenter.dart';
import 'package:evacuaid/screens/blguFamilyList.dart';
import 'package:evacuaid/screens/blguNotifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/blguSummary.dart';
import './controller/BlguNavigationController.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BlguNavigationController>(
          create: (_) => BlguNavigationController()
        )
      ],
        child: const MyApp())
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    BlguNavigationController navigation = Provider.of<BlguNavigationController>(context);
    return MaterialApp(
        home: Navigator(
          pages: [
            MaterialPage(child: BlguSummary()),
            if (navigation.screenName == '/')
              const MaterialPage(child: BlguSummary()),
            if(navigation.screenName == '/families') 
              const MaterialPage(child: BlguFamilyList()),
            if(navigation.screenName == '/centers')
              const MaterialPage(child: BlguCreateEvacCenter()),
            if(navigation.screenName == '/notifications')
              const MaterialPage(child: BlguNotifications()) 
          ],
        )
      );
  }
}