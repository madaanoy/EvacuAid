import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:evacuaid/screens/blguCreateEvacCenter.dart';
import 'package:evacuaid/screens/blguFamilyList.dart';
import 'package:evacuaid/screens/blgunotifications.dart';
import 'package:evacuaid/screens/blgusummary.dart';
import 'package:evacuaid/screens/splash_screen.dart'; // <-- We'll define this below


final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash screen route
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // BLGU routes
    GoRoute(
      name: 'summary',
      path: '/summary',
      builder: (context, state) => BlguSummary(),
    ),
    GoRoute(
      name: 'families',
      path: '/families',
      builder: (context, state) => BlguFamilyList(),
    ),
    GoRoute(
      name: 'notifications',
      path: '/notifications',
      builder: (context, state) => BlguNotifications(),
    ),

    // Camp Manager route(s)
    GoRoute(
      name: 'centers',
      path: '/centers',
      builder: (context, state) => BlguCreateEvacCenter(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

// ---------------------------------------
// Main App
// ---------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      // You can tweak your theme here
      theme: ThemeData(
        colorScheme: const ColorScheme(
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
          surfaceContainerLow: Color(0xffBDBDBD),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 28,
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            color: Color(0xff000000),
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            color: Color(0xff212121),
            fontStyle: FontStyle.italic,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            color: Color(0xff212121),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
