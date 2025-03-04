import 'package:evacuaid/screens/blguCreateEvacCenter.dart';
import 'package:evacuaid/screens/blguFamilyList.dart';
import 'package:evacuaid/screens/blguNotifications.dart';
import 'package:evacuaid/screens/blguSummary.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// GoRouter configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'summary',
      path: '/',
      builder: (context, state) => BlguSummary(),
    ),
    GoRoute(
      name: 'families',
      path: '/families',
      builder: (context, state) => BlguFamilyList(),
    ),
    GoRoute(
      name: 'centers',
      path: '/centers',
      builder: (context, state) => BlguCreateEvacCenter(),
    ),
    GoRoute(
      name: 'notifications',
      path: '/notifications',
      builder: (context, state) => BlguNotifications(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return (MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff0438D1), 
          onPrimary: Colors.white, 
          secondary: Color(0xffD10438), 
          onSecondary: Colors.white, 
          error: Color(0xffff3333), 
          onError: Colors.white, 
          surface: Colors.white, 
          onSurface: Color(0xff212121),
          outline: Color(0xffE5E5E5),
          surfaceContainer: Color(0xffF4F4F4),
          surfaceContainerLow: Color(0xffBDBDBD)
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 28,
            color: Color(0xff000000),
            fontWeight: FontWeight.bold
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            color: Color(0xff000000),
            fontWeight: FontWeight.w500
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            color: Color(0xff212121),
            fontStyle: FontStyle.italic,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            color: Color(0xff212121),
            fontWeight: FontWeight.w400
          )
        ),
      ),
    ));
  }
}
